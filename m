Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45272CA5E0
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404633AbfJCQhn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:37:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:47102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404627AbfJCQhm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:37:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D45C2086A;
        Thu,  3 Oct 2019 16:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120661;
        bh=UGqMufujAPeYf8XfJuRbDlboz+r/vDuLTwr5F1tDuSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wNnKXvnPwVr8S9KJAkA6DRR8y2OA/ay/ocVRXhtLRhYb8KD4HlXcd/G64Nqqxmdce
         HXqqsjHe2mK4I056am/fL/8YDZhd+I06faD2ErSNJIpqdMql8z/63TgISgUn7wqEFD
         xoAsOlcgY+F/6RgJStLBI4V5VFlLFFZMzyZMvXNo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        Theodore Tso <tytso@mit.edu>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.2 305/313] hwrng: core - dont wait on add_early_randomness()
Date:   Thu,  3 Oct 2019 17:54:43 +0200
Message-Id: <20191003154603.241542353@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Vivier <lvivier@redhat.com>

commit 78887832e76541f77169a24ac238fccb51059b63 upstream.

add_early_randomness() is called by hwrng_register() when the
hardware is added. If this hardware and its module are present
at boot, and if there is no data available the boot hangs until
data are available and can't be interrupted.

For instance, in the case of virtio-rng, in some cases the host can be
not able to provide enough entropy for all the guests.

We can have two easy ways to reproduce the problem but they rely on
misconfiguration of the hypervisor or the egd daemon:

- if virtio-rng device is configured to connect to the egd daemon of the
host but when the virtio-rng driver asks for data the daemon is not
connected,

- if virtio-rng device is configured to connect to the egd daemon of the
host but the egd daemon doesn't provide data.

The guest kernel will hang at boot until the virtio-rng driver provides
enough data.

To avoid that, call rng_get_data() in non-blocking mode (wait=0)
from add_early_randomness().

Signed-off-by: Laurent Vivier <lvivier@redhat.com>
Fixes: d9e797261933 ("hwrng: add randomness to system from rng...")
Cc: <stable@vger.kernel.org>
Reviewed-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/hw_random/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -67,7 +67,7 @@ static void add_early_randomness(struct
 	size_t size = min_t(size_t, 16, rng_buffer_size());
 
 	mutex_lock(&reading_mutex);
-	bytes_read = rng_get_data(rng, rng_buffer, size, 1);
+	bytes_read = rng_get_data(rng, rng_buffer, size, 0);
 	mutex_unlock(&reading_mutex);
 	if (bytes_read > 0)
 		add_device_randomness(rng_buffer, bytes_read);



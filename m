Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7ED5CABC3
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731364AbfJCP7r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 11:59:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731411AbfJCP7r (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 11:59:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB317222BE;
        Thu,  3 Oct 2019 15:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118386;
        bh=y443mZgJMPW97Mpfp8ZziGu2lKXh9L7Mmoa5z5wOjxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kWjP7BzdHfXflPCBrpeX2XpXU2MFixCfhhvMiajGcUJ7Q4ozC8+eZvirqnylnByWo
         wm6yL/F05QALGvGzmPDibzO5Rm8sZ7NXT/s/P5q8fFWtwZrJ8uQbH8kHQM5+JvHKyU
         INfknfYDE/d3eogiC4H/YZP+QvmAIzxa+ncXSd+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        Theodore Tso <tytso@mit.edu>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.4 93/99] hwrng: core - dont wait on add_early_randomness()
Date:   Thu,  3 Oct 2019 17:53:56 +0200
Message-Id: <20191003154340.534059398@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154252.297991283@linuxfoundation.org>
References: <20191003154252.297991283@linuxfoundation.org>
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
@@ -88,7 +88,7 @@ static void add_early_randomness(struct
 	size_t size = min_t(size_t, 16, rng_buffer_size());
 
 	mutex_lock(&reading_mutex);
-	bytes_read = rng_get_data(rng, rng_buffer, size, 1);
+	bytes_read = rng_get_data(rng, rng_buffer, size, 0);
 	mutex_unlock(&reading_mutex);
 	if (bytes_read > 0)
 		add_device_randomness(rng_buffer, bytes_read);



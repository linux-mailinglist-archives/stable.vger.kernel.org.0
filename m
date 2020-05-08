Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0A8C1CABC1
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729462AbgEHMqn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:46:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:48274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729458AbgEHMql (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:46:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 888D52145D;
        Fri,  8 May 2020 12:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942001;
        bh=zQEITwS3Tb1sOo6M0wkESRrjv9nok4D8igd06GWXhRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jUj14SyP8W7Cg1Pb8vCW215/y/iuJerW8nP1B/V1rqv16pwj6kWCvrTxOEN5xYGjb
         auDIcUAAmwS29ed7cFcbzQkJXsfRWdgue2V4tBKxL6xwuTfg6lcVoQlktebH6rgQDk
         474SLE6uagsCmkBR9fymES2MCfuFzm/w/CtuIj90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edward Cree <ecree@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 257/312] sfc: fix potential stack corruption from running past stat bitmask
Date:   Fri,  8 May 2020 14:34:08 +0200
Message-Id: <20200508123142.471062638@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Rybchenko <Andrew.Rybchenko@oktetlabs.ru>

commit e70c70c38d7a5ced76fc8b1c4a7ccee76e9c2911 upstream.

On 32-bit systems, mask is only an array of 3 longs, not 4, so don't try
to write to mask[3].
Also include build-time checks in case the size of the bitmask changes.

Fixes: 3c36a2aded8c ("sfc: display vadaptor statistics for all interfaces")
Signed-off-by: Edward Cree <ecree@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/sfc/ef10.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -1304,13 +1304,14 @@ static void efx_ef10_get_stat_mask(struc
 	}
 
 #if BITS_PER_LONG == 64
+	BUILD_BUG_ON(BITS_TO_LONGS(EF10_STAT_COUNT) != 2);
 	mask[0] = raw_mask[0];
 	mask[1] = raw_mask[1];
 #else
+	BUILD_BUG_ON(BITS_TO_LONGS(EF10_STAT_COUNT) != 3);
 	mask[0] = raw_mask[0] & 0xffffffff;
 	mask[1] = raw_mask[0] >> 32;
 	mask[2] = raw_mask[1] & 0xffffffff;
-	mask[3] = raw_mask[1] >> 32;
 #endif
 }
 



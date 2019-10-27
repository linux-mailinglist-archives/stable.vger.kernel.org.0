Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 174F1E6872
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731795AbfJ0VUv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:20:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:41538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731789AbfJ0VUv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:20:51 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72126205C9;
        Sun, 27 Oct 2019 21:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211251;
        bh=MlG/nRE6rDHiPOrTuZonlQNH0xqLGTMOppwMOOhlxfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r8H+DouQm4Zae8ydsBRfEYg1CzAOgxLUda8I2wagYE75I+Wkm5fFsXG5wlU7hQZWI
         5vVy2FgMR5nTHWTYA+lruCjFUC94nad5Pr8IeNVStwnrgKk7OOAkYnIBBfc92ScQBV
         4FzuWSQvV8NiW8cd5wj6GVINlo2HI87pPi/1k1aM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>,
        Igor Russkikh <igor.russkikh@aquantia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 083/197] net: aquantia: do not pass lro session with invalid tcp checksum
Date:   Sun, 27 Oct 2019 22:00:01 +0100
Message-Id: <20191027203356.188185690@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>

[ Upstream commit d08b9a0a3ebdf71b0aabe576c7dd48e57e80e0f0 ]

Individual descriptors on LRO TCP session should be checked
for CRC errors. It was discovered that HW recalculates
L4 checksums on LRO session and does not break it up on bad L4
csum.

Thus, driver should aggregate HW LRO L4 statuses from all individual
buffers of LRO session and drop packet if one of the buffers has bad
L4 checksum.

Fixes: f38f1ee8aeb2 ("net: aquantia: check rx csum for all packets in LRO session")
Signed-off-by: Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -313,6 +313,7 @@ int aq_ring_rx_clean(struct aq_ring_s *s
 					break;
 
 				buff->is_error |= buff_->is_error;
+				buff->is_cso_err |= buff_->is_cso_err;
 
 			} while (!buff_->is_eop);
 
@@ -320,7 +321,7 @@ int aq_ring_rx_clean(struct aq_ring_s *s
 				err = 0;
 				goto err_exit;
 			}
-			if (buff->is_error) {
+			if (buff->is_error || buff->is_cso_err) {
 				buff_ = buff;
 				do {
 					next_ = buff_->next,



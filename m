Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62C95441EE
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391463AbfFMQR5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:17:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:57902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731118AbfFMIk2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:40:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77B7021473;
        Thu, 13 Jun 2019 08:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415228;
        bh=7IybN8Nha+uXU8W7xnlveY2BYrbSDvSR5HmEzqawZPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OxVHTLbb6OpkhB6jy0icvbSlV+dhNUjQKo2HfgYuv+1fC67GrILtIBE8zuVgK2MyP
         eFHlcZzySCc8Hz7bjU5SCy/4VioggYFdrIpzFzMJA/w7ncSFfgFnT++gXIHMyTbwRE
         lIW+zbX1RMjp5EE4/sI+UhGtuqMUmDbpH/oRbZhY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Jankowski <shasta@toxcorp.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 050/118] netfilter: nf_conntrack_h323: restore boundary check correctness
Date:   Thu, 13 Jun 2019 10:33:08 +0200
Message-Id: <20190613075646.674221934@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075643.642092651@linuxfoundation.org>
References: <20190613075643.642092651@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f5e85ce8e733c2547827f6268136b70b802eabdb ]

Since commit bc7d811ace4a ("netfilter: nf_ct_h323: Convert
CHECK_BOUND macro to function"), NAT traversal for H.323
doesn't work, failing to parse H323-UserInformation.
nf_h323_error_boundary() compares contents of the bitstring,
not the addresses, preventing valid H.323 packets from being
conntrack'd.

This looks like an oversight from when CHECK_BOUND macro was
converted to a function.

To fix it, stop dereferencing bs->cur and bs->end.

Fixes: bc7d811ace4a ("netfilter: nf_ct_h323: Convert CHECK_BOUND macro to function")
Signed-off-by: Jakub Jankowski <shasta@toxcorp.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_h323_asn1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
index 1601275efe2d..4c2ef42e189c 100644
--- a/net/netfilter/nf_conntrack_h323_asn1.c
+++ b/net/netfilter/nf_conntrack_h323_asn1.c
@@ -172,7 +172,7 @@ static int nf_h323_error_boundary(struct bitstr *bs, size_t bytes, size_t bits)
 	if (bits % BITS_PER_BYTE > 0)
 		bytes++;
 
-	if (*bs->cur + bytes > *bs->end)
+	if (bs->cur + bytes > bs->end)
 		return 1;
 
 	return 0;
-- 
2.20.1




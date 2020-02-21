Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4A94167250
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731312AbgBUICV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:02:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:34780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731330AbgBUICU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:02:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 246BC20801;
        Fri, 21 Feb 2020 08:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272139;
        bh=9BwBJac7NVNb19LFJDio4pQeE/QC+ki3xzkjll2pn9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O0/99TY1PEAWZPpC5XBqjVXgkmxXXGxTqVQWqi8eK+bmxrLLo9xq14fKfVmtI/Zg1
         tFgp9zJIaQj1VXDm3h2i6UTiU7WQAL76c0nRq3g6aQ2Kkb9gHsX0vLK/9mS3cetEmg
         DPa4XrnEc2jcNdtFgIMvhTFnpNvIhYZMnMKbS7og=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Per Forlin <perfn@axis.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 004/344] net: dsa: tag_qca: Make sure there is headroom for tag
Date:   Fri, 21 Feb 2020 08:36:43 +0100
Message-Id: <20200221072349.705361409@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Per Forlin <per.forlin@axis.com>

[ Upstream commit 04fb91243a853dbde216d829c79d9632e52aa8d9 ]

Passing tag size to skb_cow_head will make sure
there is enough headroom for the tag data.
This change does not introduce any overhead in case there
is already available headroom for tag.

Signed-off-by: Per Forlin <perfn@axis.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dsa/tag_qca.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -33,7 +33,7 @@ static struct sk_buff *qca_tag_xmit(stru
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	u16 *phdr, hdr;
 
-	if (skb_cow_head(skb, 0) < 0)
+	if (skb_cow_head(skb, QCA_HDR_LEN) < 0)
 		return NULL;
 
 	skb_push(skb, QCA_HDR_LEN);



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7495B1BCBAA
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729092AbgD1S7G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:59:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:41894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729233AbgD1S2o (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:28:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9B37214AF;
        Tue, 28 Apr 2020 18:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098524;
        bh=eO8J7hh6A8rBgI/YiovNcnO/X1TvlHJT9v+oUP1nFq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VQVMIKhFqyhesbjoHZTTIKfgv8XVAYZxuICh6VTgCL67XlO1/jIhkEHrWFbXtVpFj
         re8UwpMd3UB0XHXIM7qA3oa7Vij/sE2+4X3MLsjzxu5DNIVR6HhzXIP0093MLeLkG9
         BYwvna6yDzMsJTg+iqfP0XjJkMpNsRbnpJDFsO+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 066/167] net: dsa: b53: Fix valid setting for MDB entries
Date:   Tue, 28 Apr 2020 20:24:02 +0200
Message-Id: <20200428182233.315245775@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit eab167f4851a19c514469dfa81147f77e17b5b20 ]

When support for the MDB entries was added, the valid bit was correctly
changed to be assigned depending on the remaining port bitmask, that is,
if there were no more ports added to the entry's port bitmask, the entry
now becomes invalid. There was another assignment a few lines below that
would override this which would invalidate entries even when there were
still multiple ports left in the MDB entry.

Fixes: 5d65b64a3d97 ("net: dsa: b53: Add support for MDB")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/b53/b53_common.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1541,7 +1541,6 @@ static int b53_arl_op(struct b53_device
 		ent.is_valid = !!(ent.port);
 	}
 
-	ent.is_valid = is_valid;
 	ent.vid = vid;
 	ent.is_static = true;
 	ent.is_age = false;



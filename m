Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 844B510BD6A
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730725AbfK0U6K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:58:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:49356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730355AbfK0U6I (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:58:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AA072084D;
        Wed, 27 Nov 2019 20:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888287;
        bh=Qu4UXCaOZOleywbTOQooncLWSu1yX+qQ4EtAGc3XE4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jr2g36wR3UEaQUocLAo2B+x81qFkRRrbgNdHIgmzjLqd8IzlDBD1gAHyJarAn4X4g
         hZDKdEbRLvTKlywwlB8H1K30oNevtz9TL/dZpjXM/VzvI4bwjLucgElBfEF9P7UtBm
         cGyQ8QqQQhfVH/dyL1GHJRD/k+W3cGpIvSLVQmak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        James Smart <james.smart@broadcom.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 076/306] nvmet-fcloop: suppress a compiler warning
Date:   Wed, 27 Nov 2019 21:28:46 +0100
Message-Id: <20191127203120.423879128@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 1216e9ef18b84f4fb5934792368fb01eb3540520 ]

Building with W=1 enables the compiler warning -Wimplicit-fallthrough=3. That
option does not recognize the fall-through comment in the fcloop driver. Add
a fall-through comment that is recognized for -Wimplicit-fallthrough=3. This
patch avoids that the compiler reports the following warning when building
with W=1:

drivers/nvme/target/fcloop.c:647:6: warning: this statement may fall through [-Wimplicit-fallthrough=]
   if (op == NVMET_FCOP_READDATA)
      ^

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: James Smart <james.smart@broadcom.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fcloop.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/target/fcloop.c b/drivers/nvme/target/fcloop.c
index 5251689a1d9ac..291f4121f516a 100644
--- a/drivers/nvme/target/fcloop.c
+++ b/drivers/nvme/target/fcloop.c
@@ -648,6 +648,7 @@ fcloop_fcp_op(struct nvmet_fc_target_port *tgtport,
 			break;
 
 		/* Fall-Thru to RSP handling */
+		/* FALLTHRU */
 
 	case NVMET_FCOP_RSP:
 		if (fcpreq) {
-- 
2.20.1




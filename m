Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1FDB19C968
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388864AbgDBTHJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:07:09 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40128 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388810AbgDBTHJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:07:09 -0400
Received: by mail-wm1-f65.google.com with SMTP id a81so4893763wmf.5
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=1/tM/QWwWwAW8oTSHIjd9lVEMMjm04LSx3ao3PWzEEA=;
        b=lK/x1nFdPg8zft+k30pfGC8o9mCqxkNztUe56eGK2iGv1j+NfPOQv6ZoGP5rHp5jdq
         f0CnIoN26gbnl4g7rNguh1b5vTcdZv7U8SxH1BFssX30Ud0XpTf1Hx2Tmz8eQiEhtaJ1
         3xtusXA+s3weOoY9VjBDRudxh68Z0GCc7zftHL9/gcTTM56+kzPviiq/rxZP/xCozvuZ
         7FfkoyCei+SMZ4N8UZ7Nd0k5rwsrmCf8+N/OeE0Z2Vb+hEhcEPTx9JH/5OEvuQMegmtT
         nB1KjNNYFn51j6m3H1UBxhQB7+Upwu5SjYWZKQpfg83L+7UmGgWQUabb6FD2fVb8+DBd
         qfZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1/tM/QWwWwAW8oTSHIjd9lVEMMjm04LSx3ao3PWzEEA=;
        b=P9NKehQbbwzFV6XlQlJ50oH9o6a9gnFAeGLCblUXJYBPt2Be73iPWL4Bvl1zBstiDn
         Mse9HP7NTHQStOh3eoJTpTq68RDqwx6L9uWLW/BGNroEW4g0cO62eQKGmc6S2bDDpdWy
         Yllr8RawOz5WtJwnTZTDcb8zfeNdVnWvsiatQ21L4UbGYZlI44f4ed656NcGZgS8Pc3O
         mSwUPXOCWa9FC1tF7Ca4XkTMUzrYcIDlOTbo+4nneiCWmmERO6JyuL525jsLJQjGyNXk
         Rr++lwU+/a4gxtXjCsWvosyGBTOniJkUN6poh4v9XCXFmj3AFLUoKRGYC2ixIGrMjxE2
         vnBQ==
X-Gm-Message-State: AGi0PubIGBmG9NJ3H8PhWupE7cxkzLeYFxfCw6lTrmnsVO2EFX2d2QKK
        iej8CTDfBl3CBNkUlyispDg=
X-Google-Smtp-Source: APiQypJ914Gt7UeiZANbmwrd/B3h72xEqyQb/Dx5X7pKPepWIzdxRWDfvYVH1Ryr4x3uGobAtn1wEg==
X-Received: by 2002:a1c:9ecb:: with SMTP id h194mr5036112wme.49.1585854428347;
        Thu, 02 Apr 2020 12:07:08 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 25sm3379433wmf.13.2020.04.02.12.07.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 Apr 2020 12:07:07 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-nvme@lists.infradead.org
Cc:     James Smart <jsmart2021@gmail.com>, stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>
Subject: [REPOST][PATCH] nvme-fc: revert controller references on lldd module
Date:   Thu,  2 Apr 2020 12:07:00 -0700
Message-Id: <20200402190700.100198-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.16.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch partially reverts the commit for
  nvme_fc: add module to ops template to allow module references

The original patch:
  Added an ops parameter of "module" to be set by the lldd, and the
    lldds were updated to provide their value.
  Used the parameter to take module references when a controller was
    created or terminated.

The original patch was to resolve the lldd being able to be unloaded
while being used to talk to the boot device of the system. However, the
end result of the original patch is that any driver unload while a nvme
controller is live via the lldd is now being prohibited. Given the module
reference, the module teardown routine can't be called, thus there's no
way, other than manual actions to terminate the controllers.

This patch reverts the portion of the patch that takes module references
on controller creation. It leaves the module parameter so that it could
be used in the future.

As such, there will still remain the issue of detaching from the boot
device, yet needing boot device access to load a new module to replace
the lldd that was unloaded. A solution will be looked for later.

-- james

Fixes: 863fbae929c7 ("nvme_fc: add module to ops template to allow module  references")
Cc: <stable@vger.kernel.org> # v5.4+
Signed-off-by: James Smart <jsmart2021@gmail.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Keith Busch <kbusch@kernel.org>

---
fix typo in description "not"->"now"
---
 drivers/nvme/host/fc.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index a8bf2fb1287b..1419c8c41fd8 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -2016,7 +2016,6 @@ nvme_fc_ctrl_free(struct kref *ref)
 {
 	struct nvme_fc_ctrl *ctrl =
 		container_of(ref, struct nvme_fc_ctrl, ref);
-	struct nvme_fc_lport *lport = ctrl->lport;
 	unsigned long flags;
 
 	if (ctrl->ctrl.tagset) {
@@ -2043,7 +2042,6 @@ nvme_fc_ctrl_free(struct kref *ref)
 	if (ctrl->ctrl.opts)
 		nvmf_free_options(ctrl->ctrl.opts);
 	kfree(ctrl);
-	module_put(lport->ops->module);
 }
 
 static void
@@ -3074,15 +3072,10 @@ nvme_fc_init_ctrl(struct device *dev, struct nvmf_ctrl_options *opts,
 		goto out_fail;
 	}
 
-	if (!try_module_get(lport->ops->module)) {
-		ret = -EUNATCH;
-		goto out_free_ctrl;
-	}
-
 	idx = ida_simple_get(&nvme_fc_ctrl_cnt, 0, 0, GFP_KERNEL);
 	if (idx < 0) {
 		ret = -ENOSPC;
-		goto out_mod_put;
+		goto out_free_ctrl;
 	}
 
 	ctrl->ctrl.opts = opts;
@@ -3232,8 +3225,6 @@ nvme_fc_init_ctrl(struct device *dev, struct nvmf_ctrl_options *opts,
 out_free_ida:
 	put_device(ctrl->dev);
 	ida_simple_remove(&nvme_fc_ctrl_cnt, ctrl->cnum);
-out_mod_put:
-	module_put(lport->ops->module);
 out_free_ctrl:
 	kfree(ctrl);
 out_fail:
-- 
2.16.4


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43FC752BAB0
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 14:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236382AbiERM0s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 08:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236379AbiERM0q (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 08:26:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1E7F69B5B;
        Wed, 18 May 2022 05:26:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51F3B61627;
        Wed, 18 May 2022 12:26:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB36C34100;
        Wed, 18 May 2022 12:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652876804;
        bh=Q6WGn+T2IYOJX+pYvJtK4Xq4x5ALfQD1/9ZqxdvFrkU=;
        h=From:To:Cc:Subject:Date:From;
        b=OMhCNOuFtmdf295e2cSWuHc1odNkmt9gZejZIdAi+F1LOeQMvNVgd0QcDC4ES6KMy
         YlEhxamD3b2ruDxZFx5cpv6wjlZ/JSV2QwLhQ8s7p2kDZQO8phxj3D93rI6+Bw6FcB
         NnFiwQjcu7GYtbqJq4lYuNSuDxP4sOOkL3edBn7AnvBUuB5/d/vano7FsIeyYGg9Wv
         KskFvIIKiIinf9j3oj3JJHL4F7LbJw8tfzc+PXQ6Lj2UYjXOCvWevfHCvIHIBpd8Jf
         1IbG21fa1o9iBp+DA2XgAmI8HveFaVybsz2QJ8fVEPUQK2AepGCal8Hat5kTozB17H
         4EfbLZBl+7F1w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brian Bunker <brian@purestorage.com>,
        Hannes Reinecke <hare@suse.de>,
        Krishna Kant <krishna.kant@purestorage.com>,
        Seamus Connor <sconnor@purestorage.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        mwilck@suse.com, dan.carpenter@oracle.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 01/23] scsi: scsi_dh_alua: Properly handle the ALUA transitioning state
Date:   Wed, 18 May 2022 08:26:14 -0400
Message-Id: <20220518122641.342120-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Bunker <brian@purestorage.com>

[ Upstream commit 6056a92ceb2a7705d61df7ec5370548e96aee258 ]

The handling of the ALUA transitioning state is currently broken. When a
target goes into this state, it is expected that the target is allowed to
stay in this state for the implicit transition timeout without a path
failure. The handler has this logic, but it gets skipped currently.

When the target transitions, there is in-flight I/O from the initiator. The
first of these responses from the target will be a unit attention letting
the initiator know that the ALUA state has changed.  The remaining
in-flight I/Os, before the initiator finds out that the portal state has
changed, will return not ready, ALUA state is transitioning. The portal
state will change to SCSI_ACCESS_STATE_TRANSITIONING. This will lead to all
new I/O immediately failing the path unexpectedly. The path failure happens
in less than a second instead of the expected successes until the
transition timer is exceeded.

Allow I/Os to continue while the path is in the ALUA transitioning
state. The handler already takes care of a target that stays in the
transitioning state for too long by changing the state to ALUA state
standby once the transition timeout is exceeded at which point the path
will fail.

Link: https://lore.kernel.org/r/CAHZQxy+4sTPz9+pY3=7VJH+CLUJsDct81KtnR2be8ycN5mhqTg@mail.gmail.com
Reviewed-by: Hannes Reinecke <hare@suse.de>
Acked-by: Krishna Kant <krishna.kant@purestorage.com>
Acked-by: Seamus Connor <sconnor@purestorage.com>
Signed-off-by: Brian Bunker <brian@purestorage.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 37d06f993b76..1d9be771f3ee 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -1172,9 +1172,8 @@ static blk_status_t alua_prep_fn(struct scsi_device *sdev, struct request *req)
 	case SCSI_ACCESS_STATE_OPTIMAL:
 	case SCSI_ACCESS_STATE_ACTIVE:
 	case SCSI_ACCESS_STATE_LBA:
-		return BLK_STS_OK;
 	case SCSI_ACCESS_STATE_TRANSITIONING:
-		return BLK_STS_AGAIN;
+		return BLK_STS_OK;
 	default:
 		req->rq_flags |= RQF_QUIET;
 		return BLK_STS_IOERR;
-- 
2.35.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8CA1593D94
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344654AbiHOTr3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344969AbiHOTp5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:45:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA1836CF57;
        Mon, 15 Aug 2022 11:48:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D665B810A0;
        Mon, 15 Aug 2022 18:48:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E205C433D6;
        Mon, 15 Aug 2022 18:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589317;
        bh=ia/EirAuhmqDledGbC0qAjRWcjTyE94Ok4hT+4Tw2wA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ttzwB+tVphylWqlwELLplfZP9RxibkdH1bICUt9oACOExRVCKP3oq86VO3Kv0ou+f
         EIax51p/wSoclmLs2Mxbk//61gc+W7zq0wevU+liQ4sNMkI+lUd01NajnSkUrbw+uJ
         X/GctdatIYFAg9xc5kdYg/O3rdk/jgOIlEchWlBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 680/779] scsi: qla2xxx: Fix losing FCP-2 targets during port perturbation tests
Date:   Mon, 15 Aug 2022 20:05:24 +0200
Message-Id: <20220815180406.429462281@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

commit 58d1c124cd79ea686b512043c5bd515590b2ed95 upstream.

When a mix of FCP-2 (tape) and non-FCP-2 targets are present, FCP-2 target
state was incorrectly transitioned when both of the targets were gone. Fix
this by ignoring state transition for FCP-2 targets.

Link: https://lore.kernel.org/r/20220616053508.27186-7-njavali@marvell.com
Fixes: 44c57f205876 ("scsi: qla2xxx: Changes to support FCP2 Target")
Cc: stable@vger.kernel.org
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_gs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3628,7 +3628,7 @@ login_logout:
 				do_delete) {
 				if (fcport->loop_id != FC_NO_LOOP_ID) {
 					if (fcport->flags & FCF_FCP2_DEVICE)
-						fcport->logout_on_delete = 0;
+						continue;
 
 					ql_log(ql_log_warn, vha, 0x20f0,
 					       "%s %d %8phC post del sess\n",



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AAD859A4A0
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353738AbiHSQnh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353568AbiHSQm0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:42:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD1E129803;
        Fri, 19 Aug 2022 09:10:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B59461831;
        Fri, 19 Aug 2022 16:09:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FCBAC433C1;
        Fri, 19 Aug 2022 16:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925380;
        bh=/wA28mbM9VZ1d0Bg4uLqGscGcBmxDWMODHf7f2bKyA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JDzgTpam7u2CiEz6SMLipX3zXbFrsPAQKdt8AyL5MYqbmCGoyiTqYBAivc9otZjJP
         XHHtHi+NY7Mc0koTct/NxTYNDeiuc7+BBDJYbWLL0LdrkHGbqY9yHpvB7ZJxDuABdN
         iz4YLI/NrEe0+OEmkGhRlo9TGrJYM+v8DIDcmDLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 444/545] scsi: qla2xxx: Fix losing FCP-2 targets during port perturbation tests
Date:   Fri, 19 Aug 2022 17:43:34 +0200
Message-Id: <20220819153849.310131661@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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
@@ -3552,7 +3552,7 @@ login_logout:
 				do_delete) {
 				if (fcport->loop_id != FC_NO_LOOP_ID) {
 					if (fcport->flags & FCF_FCP2_DEVICE)
-						fcport->logout_on_delete = 0;
+						continue;
 
 					ql_dbg(ql_dbg_disc, vha, 0x20f0,
 					    "%s %d %8phC post del sess\n",



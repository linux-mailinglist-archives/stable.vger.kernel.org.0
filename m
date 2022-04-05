Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 482B74F43AC
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 00:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242449AbiDEMSf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:18:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343740AbiDEKjl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:39:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 652896246;
        Tue,  5 Apr 2022 03:24:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07F05B81C8A;
        Tue,  5 Apr 2022 10:24:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C25EC385A0;
        Tue,  5 Apr 2022 10:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649154275;
        bh=xkC4THcyeyD6DsWcBwfm0sleeehwC2J+fOCEexg/DPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rT7xaD0+rYS5KtMibT4aAgopm1yLpY98rZqZAtQVRKisKs2+Gje7hin6wwCpVOgKc
         jMZbzD0N0SWLH/00UesAOtMbWE3nGC3Nv0jevzAlnmoKQfR673RK4hb3Xe6RnRdQYP
         OVcYEYeEjn8C0U9ztfZ6y7NN0JhdtNUvzTX5RtvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 520/599] scsi: qla2xxx: Fix warning for missing error code
Date:   Tue,  5 Apr 2022 09:33:34 +0200
Message-Id: <20220405070314.313184067@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Nilesh Javali <njavali@marvell.com>

commit 14cb838d245ae0d523b2f7804af5a02c22e79f5a upstream.

Fix smatch-reported warning message:

drivers/scsi/qla2xxx/qla_target.c:3324 qlt_xmit_response() warn: missing error
code 'res'

Link: https://lore.kernel.org/r/20220110050218.3958-12-njavali@marvell.com
Fixes: 4a8f71014b4d ("scsi: qla2xxx: Fix unmap of already freed sgl")
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_target.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3256,6 +3256,7 @@ int qlt_xmit_response(struct qla_tgt_cmd
 			"RESET-RSP online/active/old-count/new-count = %d/%d/%d/%d.\n",
 			vha->flags.online, qla2x00_reset_active(vha),
 			cmd->reset_count, qpair->chip_reset);
+		res = 0;
 		goto out_unmap_unlock;
 	}
 



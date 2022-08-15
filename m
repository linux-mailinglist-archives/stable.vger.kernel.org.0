Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96D2E59354D
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 20:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240444AbiHOSWQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240562AbiHOSVW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:21:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E550B2AE3A;
        Mon, 15 Aug 2022 11:17:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4BC9B8107A;
        Mon, 15 Aug 2022 18:16:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DAA6C433D6;
        Mon, 15 Aug 2022 18:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587418;
        bh=zEedom811/5se5b7aljK1JSNDPwuR5xYRPX2z+nxSlI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AsdWK5ASl90fgOJH4CGjojUfzJ4P+zK9pM/Pz1ZsCEtU+1toAjTQLZ6uy5GjjzAVN
         0vSiHA5S5XZdONJlVQFprqgEfG3WEMLwQBjurhrQpUENcgaR4gaxpwpmfC0O9ImEAk
         WLwnASZhqcg95MkvBAs2RxwA0cq7pqzhUWPKdTOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Bikash Hazarika <bhazarika@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 080/779] scsi: qla2xxx: Zero undefined mailbox IN registers
Date:   Mon, 15 Aug 2022 19:55:24 +0200
Message-Id: <20220815180340.728980504@linuxfoundation.org>
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

From: Bikash Hazarika <bhazarika@marvell.com>

commit 6c96a3c7d49593ef15805f5e497601c87695abc9 upstream.

While requesting a new mailbox command, driver does not write any data to
unused registers.  Initialize the unused register value to zero while
requesting a new mailbox command to prevent stale entry access by firmware.

Link: https://lore.kernel.org/r/20220713052045.10683-4-njavali@marvell.com
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Bikash Hazarika <bhazarika@marvell.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -238,6 +238,8 @@ qla2x00_mailbox_command(scsi_qla_host_t
 			ql_dbg(ql_dbg_mbx, vha, 0x1112,
 			    "mbox[%d]<-0x%04x\n", cnt, *iptr);
 			wrt_reg_word(optr, *iptr);
+		} else {
+			wrt_reg_word(optr, 0);
 		}
 
 		mboxes >>= 1;



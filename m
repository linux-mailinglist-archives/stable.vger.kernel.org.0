Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2F259A013
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350645AbiHSPzJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 11:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350466AbiHSPyO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:54:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5692B106FA2;
        Fri, 19 Aug 2022 08:49:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 751D661562;
        Fri, 19 Aug 2022 15:49:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80864C433D6;
        Fri, 19 Aug 2022 15:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924175;
        bh=bL/GLTenQQxls5QrXxno6TI51AgnSrwsBJEaUBekFeQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wsUAoI3aA3NL+neASIHDwfhvU9Tx68nER+3VdBceZcyezU1W4i3f0ycrEBOWnt6/8
         y7KGRasJnm29BqtNDYwkxMpOoczoDs6U3drNphPIe5LMDlthyvKdBgy55cSHHA9a82
         Ho2lJ6Cx7JN0m32k1UOAD4/xaxkioSXWdI06/7UM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Bikash Hazarika <bhazarika@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 052/545] scsi: qla2xxx: Zero undefined mailbox IN registers
Date:   Fri, 19 Aug 2022 17:37:02 +0200
Message-Id: <20220819153831.563404167@linuxfoundation.org>
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
@@ -233,6 +233,8 @@ qla2x00_mailbox_command(scsi_qla_host_t
 			ql_dbg(ql_dbg_mbx, vha, 0x1112,
 			    "mbox[%d]<-0x%04x\n", cnt, *iptr);
 			wrt_reg_word(optr, *iptr);
+		} else {
+			wrt_reg_word(optr, 0);
 		}
 
 		mboxes >>= 1;



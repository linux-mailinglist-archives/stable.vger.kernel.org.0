Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 612B359A4B5
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353765AbiHSQn6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353625AbiHSQme (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:42:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CFB31296FC;
        Fri, 19 Aug 2022 09:10:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC7B7B825D3;
        Fri, 19 Aug 2022 16:09:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A3EC433C1;
        Fri, 19 Aug 2022 16:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925377;
        bh=6n9zMhMjibMnoxJAvUJgUwuv1vcKVmaFXEhQLCNELsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DF/PDYCnBflffzhreUAq9/W1adzn//rhs65SSiqE6EaUzfQgBuzjaluXMHWDqp3rz
         fZ0F4VVQ2dEs88tPGcgi22jAVUup6owTeWEMW3LRG2Q8O2FudcRc9IvNDJ8hlBRjrW
         HfpwQRUpsi1YUUStxIkw9UaeEgHV/9durJIIw9FE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 443/545] scsi: qla2xxx: Fix losing FCP-2 targets on long port disable with I/Os
Date:   Fri, 19 Aug 2022 17:43:33 +0200
Message-Id: <20220819153849.261964005@linuxfoundation.org>
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

commit 2416ccd3815ba1613e10a6da0a24ef21acfe5633 upstream.

FCP-2 devices were not coming back online once they were lost, login
retries exhausted, and then came back up.  Fix this by accepting RSCN when
the device is not online.

Link: https://lore.kernel.org/r/20220616053508.27186-10-njavali@marvell.com
Fixes: 44c57f205876 ("scsi: qla2xxx: Changes to support FCP2 Target")
Cc: stable@vger.kernel.org
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_init.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1734,7 +1734,8 @@ void qla2x00_handle_rscn(scsi_qla_host_t
 	case RSCN_PORT_ADDR:
 		fcport = qla2x00_find_fcport_by_nportid(vha, &ea->id, 1);
 		if (fcport) {
-			if (fcport->flags & FCF_FCP2_DEVICE) {
+			if (fcport->flags & FCF_FCP2_DEVICE &&
+			    atomic_read(&fcport->state) == FCS_ONLINE) {
 				ql_dbg(ql_dbg_disc, vha, 0x2115,
 				       "Delaying session delete for FCP2 portid=%06x %8phC ",
 					fcport->d_id.b24, fcport->port_name);
@@ -1746,7 +1747,8 @@ void qla2x00_handle_rscn(scsi_qla_host_t
 		break;
 	case RSCN_AREA_ADDR:
 		list_for_each_entry(fcport, &vha->vp_fcports, list) {
-			if (fcport->flags & FCF_FCP2_DEVICE)
+			if (fcport->flags & FCF_FCP2_DEVICE &&
+			    atomic_read(&fcport->state) == FCS_ONLINE)
 				continue;
 
 			if ((ea->id.b24 & 0xffff00) == (fcport->d_id.b24 & 0xffff00)) {
@@ -1757,7 +1759,8 @@ void qla2x00_handle_rscn(scsi_qla_host_t
 		break;
 	case RSCN_DOM_ADDR:
 		list_for_each_entry(fcport, &vha->vp_fcports, list) {
-			if (fcport->flags & FCF_FCP2_DEVICE)
+			if (fcport->flags & FCF_FCP2_DEVICE &&
+			    atomic_read(&fcport->state) == FCS_ONLINE)
 				continue;
 
 			if ((ea->id.b24 & 0xff0000) == (fcport->d_id.b24 & 0xff0000)) {
@@ -1769,7 +1772,8 @@ void qla2x00_handle_rscn(scsi_qla_host_t
 	case RSCN_FAB_ADDR:
 	default:
 		list_for_each_entry(fcport, &vha->vp_fcports, list) {
-			if (fcport->flags & FCF_FCP2_DEVICE)
+			if (fcport->flags & FCF_FCP2_DEVICE &&
+			    atomic_read(&fcport->state) == FCS_ONLINE)
 				continue;
 
 			fcport->scan_needed = 1;



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22938549967
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234687AbiFMQ7H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 12:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242159AbiFMQ6m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 12:58:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3AA24586;
        Mon, 13 Jun 2022 04:51:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE882B80EB2;
        Mon, 13 Jun 2022 11:51:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 485FAC34114;
        Mon, 13 Jun 2022 11:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655121110;
        bh=mPsGNySn/Djaegr/QEJx29Yg9SM3eEAgYtMG5qqaa+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hlB2L+8SldjFmNfjcBQUUToqyp21y/8EdW9QTlUc3a/09MQTziHtJ/AJGxN9pGa5m
         zn40l/4BYmzFDm/5n2tEHDmSzawld/VdG08QozDQvMp+qqSfPaaLk78ld3OKGSIWyS
         I8zTH9ahjbEBooLN8hGeF0CWOjQuNC52Op3C1CvA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tyler Erickson <tyler.erickson@seagate.com>,
        Muhammad Ahmad <muhammad.ahmad@seagate.com>,
        Michael English <michael.english@seagate.com>,
        Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH 5.17 268/298] libata: fix translation of concurrent positioning ranges
Date:   Mon, 13 Jun 2022 12:12:42 +0200
Message-Id: <20220613094933.201175397@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tyler Erickson <tyler.erickson@seagate.com>

commit 6d11acd452fd885ef6ace184c9c70bc863a8c72f upstream.

Fixing the page length in the SCSI translation for the concurrent
positioning ranges VPD page. It was writing starting in offset 3
rather than offset 2 where the MSB is supposed to start for
the VPD page length.

Cc: stable@vger.kernel.org
Fixes: fe22e1c2f705 ("libata: support concurrent positioning ranges log")
Signed-off-by: Tyler Erickson <tyler.erickson@seagate.com>
Reviewed-by: Muhammad Ahmad <muhammad.ahmad@seagate.com>
Tested-by: Michael English <michael.english@seagate.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-scsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2119,7 +2119,7 @@ static unsigned int ata_scsiop_inq_b9(st
 
 	/* SCSI Concurrent Positioning Ranges VPD page: SBC-5 rev 1 or later */
 	rbuf[1] = 0xb9;
-	put_unaligned_be16(64 + (int)cpr_log->nr_cpr * 32 - 4, &rbuf[3]);
+	put_unaligned_be16(64 + (int)cpr_log->nr_cpr * 32 - 4, &rbuf[2]);
 
 	for (i = 0; i < cpr_log->nr_cpr; i++, desc += 32) {
 		desc[0] = cpr_log->cpr[i].num;



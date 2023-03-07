Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5D76AEC04
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbjCGRvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:51:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232178AbjCGRue (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:50:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C159A2F1F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:45:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD5C0B819B4
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:45:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CDC3C433EF;
        Tue,  7 Mar 2023 17:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211138;
        bh=+JqRYGk7xqyH2ZR1SbB3gPp/ILRyVUZwlXqz7exnFPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fAj3FQUMLSK/Qd4WVfWC2W+uBl8kr6cx3X63Z2c96OfKVBSqubbDIXwolN4FF3YH4
         zjqfV5nz9ka5/d4weGTw6lg4sGNfgt/K2WzB4j62qo5Xtluu0CS1d6XWXy24hylmWG
         aB5nE57ZrA45rqMdNMXwXl91rnI0rdOLhjI/aoGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sven Schnelle <svens@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.2 0766/1001] s390/ipl: add loadparm parameter to eckd ipl/reipl data
Date:   Tue,  7 Mar 2023 17:58:58 +0100
Message-Id: <20230307170055.006510681@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@linux.ibm.com>

commit 6bb361d5d8eb1dbc9e0b190eeee27a2ac4d1119f upstream.

commit 87fd22e0ae92 ("s390/ipl: add eckd support") missed to add the
loadparm attribute to the new eckd ipl/reipl data.

Fixes: 87fd22e0ae92 ("s390/ipl: add eckd support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/ipl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/s390/kernel/ipl.c b/arch/s390/kernel/ipl.c
index d7b433261145..5f0f5c86963a 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -593,6 +593,7 @@ static struct attribute *ipl_eckd_attrs[] = {
 	&sys_ipl_type_attr.attr,
 	&sys_ipl_eckd_bootprog_attr.attr,
 	&sys_ipl_eckd_br_chr_attr.attr,
+	&sys_ipl_ccw_loadparm_attr.attr,
 	&sys_ipl_device_attr.attr,
 	&sys_ipl_secure_attr.attr,
 	&sys_ipl_has_secure_attr.attr,
@@ -908,6 +909,7 @@ DEFINE_GENERIC_LOADPARM(fcp);
 DEFINE_GENERIC_LOADPARM(nvme);
 DEFINE_GENERIC_LOADPARM(ccw);
 DEFINE_GENERIC_LOADPARM(nss);
+DEFINE_GENERIC_LOADPARM(eckd);
 
 static ssize_t reipl_fcp_clear_show(struct kobject *kobj,
 				    struct kobj_attribute *attr, char *page)
@@ -1129,6 +1131,7 @@ static struct attribute *reipl_eckd_attrs[] = {
 	&sys_reipl_eckd_device_attr.attr,
 	&sys_reipl_eckd_bootprog_attr.attr,
 	&sys_reipl_eckd_br_chr_attr.attr,
+	&sys_reipl_eckd_loadparm_attr.attr,
 	NULL,
 };
 
-- 
2.39.2




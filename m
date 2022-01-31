Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0AF44A40A6
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 11:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244454AbiAaK6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 05:58:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244667AbiAaK6r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 05:58:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC141C061741;
        Mon, 31 Jan 2022 02:58:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E56460AD6;
        Mon, 31 Jan 2022 10:58:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD49C340E8;
        Mon, 31 Jan 2022 10:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643626726;
        bh=kvmeKDKq4ruE2gAqLGR7+eCTMNUXOvT8e/qFwT9YNBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ALnPbrkjpcpjzEm5aVTjxP78DNrDkT6AV5guUuXGqTBXHV1lTl1ftqFPzlemMH8fM
         VWi1yIY5YUPbAP5CxhXeeiY9237LRvUMB71fYq8Ns7eF/KPwM9lFp6OmDIxSFITqI2
         dTa08UXHIunXpQfjK4qgTdlBoHVdZ0TnyIv7vz4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.4 02/64] s390/hypfs: include z/VM guests with access control group set
Date:   Mon, 31 Jan 2022 11:55:47 +0100
Message-Id: <20220131105215.724794699@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105215.644174521@linuxfoundation.org>
References: <20220131105215.644174521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

commit 663d34c8df98740f1e90241e78e456d00b3c6cad upstream.

Currently if z/VM guest is allowed to retrieve hypervisor performance
data globally for all guests (privilege class B) the query is formed in a
way to include all guests but the group name is left empty. This leads to
that z/VM guests which have access control group set not being included
in the results (even local vm).

Change the query group identifier from empty to "any" to retrieve
information about all guests from any groups (or without a group set).

Cc: stable@vger.kernel.org
Fixes: 31cb4bd31a48 ("[S390] Hypervisor filesystem (s390_hypfs) for z/VM")
Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/hypfs/hypfs_vm.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/s390/hypfs/hypfs_vm.c
+++ b/arch/s390/hypfs/hypfs_vm.c
@@ -20,6 +20,7 @@
 
 static char local_guest[] = "        ";
 static char all_guests[] = "*       ";
+static char *all_groups = all_guests;
 static char *guest_query;
 
 struct diag2fc_data {
@@ -62,10 +63,11 @@ static int diag2fc(int size, char* query
 
 	memcpy(parm_list.userid, query, NAME_LEN);
 	ASCEBC(parm_list.userid, NAME_LEN);
-	parm_list.addr = (unsigned long) addr ;
+	memcpy(parm_list.aci_grp, all_groups, NAME_LEN);
+	ASCEBC(parm_list.aci_grp, NAME_LEN);
+	parm_list.addr = (unsigned long)addr;
 	parm_list.size = size;
 	parm_list.fmt = 0x02;
-	memset(parm_list.aci_grp, 0x40, NAME_LEN);
 	rc = -1;
 
 	diag_stat_inc(DIAG_STAT_X2FC);



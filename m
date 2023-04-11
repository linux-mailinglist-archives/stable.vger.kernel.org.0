Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4A696DD0A2
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 06:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbjDKECo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 00:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjDKECn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 00:02:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B4E98;
        Mon, 10 Apr 2023 21:02:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6F5F6187F;
        Tue, 11 Apr 2023 04:02:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09417C433EF;
        Tue, 11 Apr 2023 04:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681185761;
        bh=8VF1/xKDqzJB/TUDQUA+T8VtQji3mOdJGsHVFMQX0FM=;
        h=Date:To:From:Subject:From;
        b=kTqQbjSQrQQMECZXEBIJ+dfwORSTPdEB5FL4e3xlkRIAZvgFvWhiZpnAURrrnt5GV
         vvOeVNnAGebhG1fhM34tkOvWzm5CINii2U5k7jJMLWRevD3QblaNb+GmbBDXfu4ZLy
         umQwS4TfN1RUW7ZmSAZUoOhGYfeD8ome8RnGLX6k=
Date:   Mon, 10 Apr 2023 21:02:40 -0700
To:     mm-commits@vger.kernel.org, yejiajian2018@email.szu.edu.cn,
        stable@vger.kernel.org, steve_chou@pesi.com.tw,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-mm-page_owner_sortc-fix-tgid-output-when-cull=tg-is-used.patch added to mm-hotfixes-unstable branch
Message-Id: <20230411040241.09417C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: tools/mm/page_owner_sort.c: fix TGID output when cull=tg is used
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     tools-mm-page_owner_sortc-fix-tgid-output-when-cull=tg-is-used.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-mm-page_owner_sortc-fix-tgid-output-when-cull=tg-is-used.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Steve Chou <steve_chou@pesi.com.tw>
Subject: tools/mm/page_owner_sort.c: fix TGID output when cull=tg is used
Date: Tue, 11 Apr 2023 11:49:28 +0800

When using cull option with 'tg' flag, the fprintf is using pid instead
of tgid. It should use tgid instead.

Link: https://lkml.kernel.org/r/20230411034929.2071501-1-steve_chou@pesi.com.tw
Fixes: 9c8a0a8e599f4a ("tools/vm/page_owner_sort.c: support for user-defined culling rules")
Signed-off-by: Steve Chou <steve_chou@pesi.com.tw>
Cc: Jiajian Ye <yejiajian2018@email.szu.edu.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/page_owner_sort.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/mm/page_owner_sort.c~tools-mm-page_owner_sortc-fix-tgid-output-when-cull=tg-is-used
+++ a/tools/mm/page_owner_sort.c
@@ -857,7 +857,7 @@ int main(int argc, char **argv)
 			if (cull & CULL_PID || filter & FILTER_PID)
 				fprintf(fout, ", PID %d", list[i].pid);
 			if (cull & CULL_TGID || filter & FILTER_TGID)
-				fprintf(fout, ", TGID %d", list[i].pid);
+				fprintf(fout, ", TGID %d", list[i].tgid);
 			if (cull & CULL_COMM || filter & FILTER_COMM)
 				fprintf(fout, ", task_comm_name: %s", list[i].comm);
 			if (cull & CULL_ALLOCATOR) {
_

Patches currently in -mm which might be from steve_chou@pesi.com.tw are

tools-mm-page_owner_sortc-fix-tgid-output-when-cull=tg-is-used.patch


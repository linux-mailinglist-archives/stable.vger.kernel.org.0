Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22A746ECE7D
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232482AbjDXNdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232547AbjDXNco (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:32:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16BED72A0
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:32:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E0F3622E1
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:31:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35592C433EF;
        Mon, 24 Apr 2023 13:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343093;
        bh=yNf+6MgrW2TLuDgOW6ptHVlZmMXDPGptF4rVUsUo/sU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H1GNRXbkAD9qPDZZrsNsMvWHChvhUbneEifmiHaP/eUn2nKABLL6iRIA9aefOtKno
         O8OmWkPX56x16gJmxZ+qh2nVd4wZWVAb0vtWpJge9PWE6sOfPJeHwy61ykraS6nNtg
         XbdyafzB/L12nBu+FnPOdQs3vMYzvmLcLVJkTvuo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Steve Chou <steve_chou@pesi.com.tw>,
        Jiajian Ye <yejiajian2018@email.szu.edu.cn>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.2 075/110] tools/mm/page_owner_sort.c: fix TGID output when cull=tg is used
Date:   Mon, 24 Apr 2023 15:17:37 +0200
Message-Id: <20230424131139.230156417@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve Chou <steve_chou@pesi.com.tw>

commit 9235756885e865070c4be2facda75262dbd85967 upstream.

When using cull option with 'tg' flag, the fprintf is using pid instead
of tgid. It should use tgid instead.

Link: https://lkml.kernel.org/r/20230411034929.2071501-1-steve_chou@pesi.com.tw
Fixes: 9c8a0a8e599f4a ("tools/vm/page_owner_sort.c: support for user-defined culling rules")
Signed-off-by: Steve Chou <steve_chou@pesi.com.tw>
Cc: Jiajian Ye <yejiajian2018@email.szu.edu.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/vm/page_owner_sort.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/vm/page_owner_sort.c
+++ b/tools/vm/page_owner_sort.c
@@ -847,7 +847,7 @@ int main(int argc, char **argv)
 			if (cull & CULL_PID || filter & FILTER_PID)
 				fprintf(fout, ", PID %d", list[i].pid);
 			if (cull & CULL_TGID || filter & FILTER_TGID)
-				fprintf(fout, ", TGID %d", list[i].pid);
+				fprintf(fout, ", TGID %d", list[i].tgid);
 			if (cull & CULL_COMM || filter & FILTER_COMM)
 				fprintf(fout, ", task_comm_name: %s", list[i].comm);
 			if (cull & CULL_ALLOCATOR) {



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB36594D27
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347591AbiHPAcR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353182AbiHPAbO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:31:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC06185985;
        Mon, 15 Aug 2022 13:36:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE14C611FC;
        Mon, 15 Aug 2022 20:35:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6A8C433C1;
        Mon, 15 Aug 2022 20:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595732;
        bh=LDycKYnW6ye4o2A+N5sKquPsWFCQPRnl7ImjLXfcl90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uidPro0txmgm5UR4FYB9jgjAZ/N8lf+uqmgQP42sgv1zOsqb9torGRRsuRPUBBToV
         lDw9ZWIW+Tojf+0eek4ShwAoTcTNCTvqduoeiw5/IWg34OMNFs9PYdjFXdRuJY9YBO
         CLWbTUxML0t/nO8mB+k79KtVeZBzGnzL9r+KBG0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0856/1157] tools/power/x86/intel-speed-select: Fix off by one check
Date:   Mon, 15 Aug 2022 20:03:32 +0200
Message-Id: <20220815180513.728398277@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit d9f74d98bbec978edbf860f729b531281ba0d8ff ]

Change > MAX_DIE_PER_PACKAGE to >= MAX_DIE_PER_PACKAGE to prevent
accessing one element beyond the end of the array.

Fixes: 7fd786dfbd2c ("tools/power/x86/intel-speed-select: OOB daemon mode")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/intel-speed-select/isst-daemon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/power/x86/intel-speed-select/isst-daemon.c b/tools/power/x86/intel-speed-select/isst-daemon.c
index dd372924bc82..d0400c6684ba 100644
--- a/tools/power/x86/intel-speed-select/isst-daemon.c
+++ b/tools/power/x86/intel-speed-select/isst-daemon.c
@@ -41,7 +41,7 @@ void process_level_change(int cpu)
 	time_t tm;
 	int ret;
 
-	if (pkg_id >= MAX_PACKAGE_COUNT || die_id > MAX_DIE_PER_PACKAGE) {
+	if (pkg_id >= MAX_PACKAGE_COUNT || die_id >= MAX_DIE_PER_PACKAGE) {
 		debug_printf("Invalid package/die info for cpu:%d\n", cpu);
 		return;
 	}
-- 
2.35.1




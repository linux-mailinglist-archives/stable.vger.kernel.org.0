Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FEED541728
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357007AbiFGU7p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377724AbiFGU6s (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:58:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7416C20A087;
        Tue,  7 Jun 2022 11:44:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA3ED61295;
        Tue,  7 Jun 2022 18:44:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C137DC385A2;
        Tue,  7 Jun 2022 18:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627483;
        bh=h96rxag+E6cq0S1AR/1pcZZD3EluK5LjxM3GIvxyU98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rQ7FBYoOjBhy2zYzMkB0qeW/Nfkoob7ewrZedWr8QWecI7tVRf4cw6ep7XP/d+wuS
         5quHX5mJG58B+iHE3T31NBLFFRKDn6mFGxsihHWoG0PJznAV9Mb6o9ZqeEtR14qXxH
         ajLPDAEp9d0mQI1BRx8fsuEcDblem1+btOiBHFwI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Waiman Long <longman@redhat.com>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 5.17 756/772] kseltest/cgroup: Make test_stress.sh work if run interactively
Date:   Tue,  7 Jun 2022 19:05:48 +0200
Message-Id: <20220607165011.302859805@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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

From: Waiman Long <longman@redhat.com>

commit 213adc63dfbcdff9a0c19ec1f2681fda9c05cf6d upstream.

Commit 54de76c01239 ("kselftest/cgroup: fix test_stress.sh to use OUTPUT
dir") changes the test_core command path from . to $OUTPUT. However,
variable OUTPUT may not be defined if the command is run interactively.
Fix that by using ${OUTPUT:-.} to cover both cases.

Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/cgroup/test_stress.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/cgroup/test_stress.sh
+++ b/tools/testing/selftests/cgroup/test_stress.sh
@@ -1,4 +1,4 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
-./with_stress.sh -s subsys -s fork ${OUTPUT}/test_core
+./with_stress.sh -s subsys -s fork ${OUTPUT:-.}/test_core



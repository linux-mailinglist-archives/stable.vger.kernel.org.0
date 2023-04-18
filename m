Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4206E61CD
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbjDRM2B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231382AbjDRM16 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:27:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A816B758
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:27:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5768D6313B
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:27:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C9EEC433EF;
        Tue, 18 Apr 2023 12:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681820838;
        bh=+4WkvlBKt0fZRLd0azoyPPnH7XVc21Df0UneaJ6iYTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZdPHGDcXTQccy1uC6vNzjY0CYUh1ygAwvgqp2bXYzK0UI1CHE1xH8MCHI8kcQAKxp
         5R0AIBCN2HsBzOQcC6zqk1j5AMoHmb8IboYtbjb3VVu5GSTzA/ilmrkjXwZOQw3YyM
         Ypd15633slQ+RkVnyQzT6AmaQkalRZSQVZUPyB7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Waiman Long <longman@redhat.com>,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 4.19 51/57] cgroup/cpuset: Wake up cpuset_attach_wq tasks in cpuset_cancel_attach()
Date:   Tue, 18 Apr 2023 14:21:51 +0200
Message-Id: <20230418120300.522651013@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120258.713853188@linuxfoundation.org>
References: <20230418120258.713853188@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

commit ba9182a89626d5f83c2ee4594f55cb9c1e60f0e2 upstream.

After a successful cpuset_can_attach() call which increments the
attach_in_progress flag, either cpuset_cancel_attach() or cpuset_attach()
will be called later. In cpuset_attach(), tasks in cpuset_attach_wq,
if present, will be woken up at the end. That is not the case in
cpuset_cancel_attach(). So missed wakeup is possible if the attach
operation is somehow cancelled. Fix that by doing the wakeup in
cpuset_cancel_attach() as well.

Fixes: e44193d39e8d ("cpuset: let hotplug propagation work wait for task attaching")
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Cc: stable@vger.kernel.org # v3.11+
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cpuset.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1504,7 +1504,9 @@ static void cpuset_cancel_attach(struct
 	cs = css_cs(css);
 
 	mutex_lock(&cpuset_mutex);
-	css_cs(css)->attach_in_progress--;
+	cs->attach_in_progress--;
+	if (!cs->attach_in_progress)
+		wake_up(&cpuset_attach_wq);
 	mutex_unlock(&cpuset_mutex);
 }
 



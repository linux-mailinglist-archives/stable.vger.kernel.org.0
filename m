Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A05C6280B3
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237863AbiKNNIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:08:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237866AbiKNNIQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:08:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB37E2AC75
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:08:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77BD36109A
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:08:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76BBAC433D6;
        Mon, 14 Nov 2022 13:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431293;
        bh=D+DCsuIcRJ4vbV4E3qA1L+0bPBEs8zBxwZkkEeLmORE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UMllzzZNLCouy9Uv90s5XkqIBsNaXqO0ONX4joUa/T0gF71XQqulovV6KqI76KDsh
         3LLrmQ+MB0jyUvPZJb2AoVluVlg34nm/7xrzviW686fKVk7faEGKdsFLDou842BBiW
         sYSr0+9q1aleSor0gI20vVjPCFvILq8PrYYeLn3w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Felix Kuehling <Felix.Kuehling@amd.com>,
        Rajneesh Bhardwaj <rajneesh.bhardwaj@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 143/190] drm/amdkfd: Fix error handling in kfd_criu_restore_events
Date:   Mon, 14 Nov 2022 13:46:07 +0100
Message-Id: <20221114124505.049330709@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Kuehling <Felix.Kuehling@amd.com>

commit 66f7903779fbbc620bf1040017e4833ef6a0b541 upstream.

mutex_unlock before the exit label because all the error code paths that
jump there didn't take that lock. This fixes unbalanced locking errors
in case of restore errors.

Fixes: 40e8a766a761 ("drm/amdkfd: CRIU checkpoint and restore events")
Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Rajneesh Bhardwaj <rajneesh.bhardwaj@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_events.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_events.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
@@ -506,6 +506,7 @@ int kfd_criu_restore_event(struct file *
 		ret = create_other_event(p, ev, &ev_priv->event_id);
 		break;
 	}
+	mutex_unlock(&p->event_mutex);
 
 exit:
 	if (ret)
@@ -513,8 +514,6 @@ exit:
 
 	kfree(ev_priv);
 
-	mutex_unlock(&p->event_mutex);
-
 	return ret;
 }
 



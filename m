Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24B0351A947
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354452AbiEDRMn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356873AbiEDRJr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE772443C3;
        Wed,  4 May 2022 09:56:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1261B82552;
        Wed,  4 May 2022 16:56:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53BE9C385A4;
        Wed,  4 May 2022 16:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683370;
        bh=mByOyQJpflwm3yp0gkyUjgqQy6QgDdF3JuD8miju9pY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HyYh0HjSv7N8IKB23eTSxZIPdNCM6JmD5w28QHG1TpCcC5ZzO1YIurnN5aL4ZpS54
         4Z8TkuYKc9UgGK/OprBohpPEbKVHAmPySFQIA1/YPdMo4j97zchEepQ+D0yJXQaIfY
         YPlaJA+jQfs90S0SC9OB8e846hSXKshCkoRr1cxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiubo Li <xiubli@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Aaron Tomlin <atomlin@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.17 041/225] ceph: fix possible NULL pointer dereference for req->r_session
Date:   Wed,  4 May 2022 18:44:39 +0200
Message-Id: <20220504153113.829524458@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

commit 7acae6183cf37c48b8da48bbbdb78820fb3913f3 upstream.

The request will be inserted into the ci->i_unsafe_dirops before
assigning the req->r_session, so it's possible that we will hit
NULL pointer dereference bug here.

Cc: stable@vger.kernel.org
URL: https://tracker.ceph.com/issues/55327
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Tested-by: Aaron Tomlin <atomlin@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/caps.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2267,6 +2267,8 @@ retry:
 			list_for_each_entry(req, &ci->i_unsafe_dirops,
 					    r_unsafe_dir_item) {
 				s = req->r_session;
+				if (!s)
+					continue;
 				if (unlikely(s->s_mds >= max_sessions)) {
 					spin_unlock(&ci->i_unsafe_lock);
 					for (i = 0; i < max_sessions; i++) {
@@ -2287,6 +2289,8 @@ retry:
 			list_for_each_entry(req, &ci->i_unsafe_iops,
 					    r_unsafe_target_item) {
 				s = req->r_session;
+				if (!s)
+					continue;
 				if (unlikely(s->s_mds >= max_sessions)) {
 					spin_unlock(&ci->i_unsafe_lock);
 					for (i = 0; i < max_sessions; i++) {



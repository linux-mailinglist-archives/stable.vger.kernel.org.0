Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70EB451A812
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355305AbiEDRHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355293AbiEDREQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:04:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D0014EA2F;
        Wed,  4 May 2022 09:52:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F7C66181D;
        Wed,  4 May 2022 16:52:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91412C385A5;
        Wed,  4 May 2022 16:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683169;
        bh=q4qRcixjZfwyrHDVj2jNoFv5DwrF7PikIhtG3Ad2Q6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iw4PR6eUCDZRXRe6XfnYbSrASzRhft+O3OY76LAYb/Q80dUbGW2hHCrBCsOU/242k
         trUGeRwBtSFhH2iVQmhtzhnJVz3PBmDuPX3UT2zQAjPEYfEXKkAmj10ZIhbYlS6uy7
         y4w64k4l6GZnJUM/TTdzj1oc+kRByAscwzvKOhMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiubo Li <xiubli@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Aaron Tomlin <atomlin@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.15 034/177] ceph: fix possible NULL pointer dereference for req->r_session
Date:   Wed,  4 May 2022 18:43:47 +0200
Message-Id: <20220504153056.012271165@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
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
@@ -2266,6 +2266,8 @@ retry:
 			list_for_each_entry(req, &ci->i_unsafe_dirops,
 					    r_unsafe_dir_item) {
 				s = req->r_session;
+				if (!s)
+					continue;
 				if (unlikely(s->s_mds >= max_sessions)) {
 					spin_unlock(&ci->i_unsafe_lock);
 					for (i = 0; i < max_sessions; i++) {
@@ -2286,6 +2288,8 @@ retry:
 			list_for_each_entry(req, &ci->i_unsafe_iops,
 					    r_unsafe_target_item) {
 				s = req->r_session;
+				if (!s)
+					continue;
 				if (unlikely(s->s_mds >= max_sessions)) {
 					spin_unlock(&ci->i_unsafe_lock);
 					for (i = 0; i < max_sessions; i++) {



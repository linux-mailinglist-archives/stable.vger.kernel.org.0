Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CADEC34C827
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233258AbhC2IUH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:20:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:35278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232947AbhC2ITa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:19:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D56B1619CF;
        Mon, 29 Mar 2021 08:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005970;
        bh=zw6S8tYGfZUBG887EXZd/vUxE9n2eI80yfCF6RuGaLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bw/sh0smtm/+JlsQVdE8B6d4D9+3g5BlumCOeD/5sn75ZgOZrFkyv0Ogw8lytI9Jv
         YjAsVZAC2zkUAlX4SmK2dQJwvYY/X+cKF5KcIMQkFwiMgcfdwQ8kE7PxbjhkSsHy7+
         fKinmbvl8VBJVPoBLiwrRP7aa3FiiTFbAGaheMxw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.10 063/221] selinux: dont log MAC_POLICY_LOAD record on failed policy load
Date:   Mon, 29 Mar 2021 09:56:34 +0200
Message-Id: <20210329075631.295856056@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ondrej Mosnacek <omosnace@redhat.com>

commit 519dad3bcd809dc1523bf80ab0310ddb3bf00ade upstream.

If sel_make_policy_nodes() fails, we should jump to 'out', not 'out1',
as the latter would incorrectly log an MAC_POLICY_LOAD audit record,
even though the policy hasn't actually been reloaded. The 'out1' jump
label now becomes unused and can be removed.

Fixes: 02a52c5c8c3b ("selinux: move policy commit after updating selinuxfs")
Cc: stable@vger.kernel.org
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/selinuxfs.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -651,14 +651,13 @@ static ssize_t sel_write_load(struct fil
 	length = sel_make_policy_nodes(fsi, newpolicy);
 	if (length) {
 		selinux_policy_cancel(fsi->state, newpolicy);
-		goto out1;
+		goto out;
 	}
 
 	selinux_policy_commit(fsi->state, newpolicy);
 
 	length = count;
 
-out1:
 	audit_log(audit_context(), GFP_KERNEL, AUDIT_MAC_POLICY_LOAD,
 		"auid=%u ses=%u lsm=selinux res=1",
 		from_kuid(&init_user_ns, audit_get_loginuid(current)),



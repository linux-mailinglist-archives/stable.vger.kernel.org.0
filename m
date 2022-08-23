Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2FDE59DBEC
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358457AbiHWLtn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358466AbiHWLsw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:48:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD2A9923EB;
        Tue, 23 Aug 2022 02:30:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFCB8612B5;
        Tue, 23 Aug 2022 09:30:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04F9C433D6;
        Tue, 23 Aug 2022 09:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247046;
        bh=70k56DN1QaIC2xcKlwpIxCt7qEkHCLZyd+7FQNKIsDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wyt7AKQs2gCDIRF8aXlxk7gK8iINzq/Zk2+JzDJKNGCKyBIYd9RzVptWnHDMHuWwa
         8vQiKrC2oubRzRqJ2Xc+ioZCPI0MsrSFN9hhNztfToLGtZjBYXuSf0rQiMMcKz3hFF
         d8/QV4lcOAndX9HhVDxo5BAm6n2ZuPHLK5FXYpLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Johansen <john.johansen@canonical.com>
Subject: [PATCH 5.4 294/389] apparmor: fix quiet_denied for file rules
Date:   Tue, 23 Aug 2022 10:26:12 +0200
Message-Id: <20220823080127.843122279@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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

From: John Johansen <john.johansen@canonical.com>

commit 68ff8540cc9e4ab557065b3f635c1ff4c96e1f1c upstream.

Global quieting of denied AppArmor generated file events is not
handled correctly. Unfortunately the is checking if quieting of all
audit events is set instead of just denied events.

Fixes: 67012e8209df ("AppArmor: basic auditing infrastructure.")
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/audit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/security/apparmor/audit.c
+++ b/security/apparmor/audit.c
@@ -139,7 +139,7 @@ int aa_audit(int type, struct aa_profile
 	}
 	if (AUDIT_MODE(profile) == AUDIT_QUIET ||
 	    (type == AUDIT_APPARMOR_DENIED &&
-	     AUDIT_MODE(profile) == AUDIT_QUIET))
+	     AUDIT_MODE(profile) == AUDIT_QUIET_DENIED))
 		return aad(sa)->error;
 
 	if (KILL_MODE(profile) && type == AUDIT_APPARMOR_DENIED)



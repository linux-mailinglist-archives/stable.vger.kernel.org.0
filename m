Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6DEB59DA5A
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352132AbiHWKHZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352529AbiHWKFv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:05:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9069F6B672;
        Tue, 23 Aug 2022 01:52:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2504E6150F;
        Tue, 23 Aug 2022 08:52:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342ADC433D6;
        Tue, 23 Aug 2022 08:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244725;
        bh=o5kMqKGNeYaD1QjftcGevNh2DTWdrdudlXdleTnx8zM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eejVIGHQ3sBSZ7nONPs8Dfsd3ZCO9M9lBjgpj1fBjP/AcYUdfepBfKq92z2O1nH+h
         xBvCCHm+XpiuqPS+IsYoC/qFhsm1AL5npbE7gV2l/khvlJoVIntt5FZQpeosQvdz3X
         gQiRSPtyYO5dmMKt9OlQWA8MDmVwxUY7+/pzqvSc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Johansen <john.johansen@canonical.com>
Subject: [PATCH 4.14 181/229] apparmor: fix quiet_denied for file rules
Date:   Tue, 23 Aug 2022 10:25:42 +0200
Message-Id: <20220823080100.081326681@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
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
@@ -143,7 +143,7 @@ int aa_audit(int type, struct aa_profile
 	}
 	if (AUDIT_MODE(profile) == AUDIT_QUIET ||
 	    (type == AUDIT_APPARMOR_DENIED &&
-	     AUDIT_MODE(profile) == AUDIT_QUIET))
+	     AUDIT_MODE(profile) == AUDIT_QUIET_DENIED))
 		return aad(sa)->error;
 
 	if (KILL_MODE(profile) && type == AUDIT_APPARMOR_DENIED)



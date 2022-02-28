Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2674C75C9
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235986AbiB1R40 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:56:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240757AbiB1Rye (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:54:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B88BE50072;
        Mon, 28 Feb 2022 09:42:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A4326066C;
        Mon, 28 Feb 2022 17:42:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 501C2C340E7;
        Mon, 28 Feb 2022 17:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070178;
        bh=ACZ/mF0AOC6mrgyh/xkDP9r2lrB+sF7VRAOiOBErrLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vGbL3W8/4hWn88wJ0lfPMZXz0Gv7sM3Xp/b3b3PN/l754/L+7XixQBlykLi76CqD2
         wwCKBEe/857e6exax22MmXk0Vw59z37jQuZuVh8x/xDBR7iB92mtJMP5vdGoS9B9og
         sXzYX72sj7zyhuDZekKwcrUCHJV96JNsFWfDSrgk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.16 015/164] KVM: x86: nSVM: disallow userspace setting of MSR_AMD64_TSC_RATIO to non default value when tsc scaling disabled
Date:   Mon, 28 Feb 2022 18:22:57 +0100
Message-Id: <20220228172401.290195192@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

commit e910a53fb4f20aa012e46371ffb4c32c8da259b4 upstream.

If nested tsc scaling is disabled, MSR_AMD64_TSC_RATIO should
never have non default value.

Due to way nested tsc scaling support was implmented in qemu,
it would set this msr to 0 when nested tsc scaling was disabled.
Ignore that value for now, as it causes no harm.

Fixes: 5228eb96a487 ("KVM: x86: nSVM: implement nested TSC scaling")
Cc: stable@vger.kernel.org

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20220223115649.319134-1-mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2903,8 +2903,23 @@ static int svm_set_msr(struct kvm_vcpu *
 	u64 data = msr->data;
 	switch (ecx) {
 	case MSR_AMD64_TSC_RATIO:
-		if (!msr->host_initiated && !svm->tsc_scaling_enabled)
-			return 1;
+
+		if (!svm->tsc_scaling_enabled) {
+
+			if (!msr->host_initiated)
+				return 1;
+			/*
+			 * In case TSC scaling is not enabled, always
+			 * leave this MSR at the default value.
+			 *
+			 * Due to bug in qemu 6.2.0, it would try to set
+			 * this msr to 0 if tsc scaling is not enabled.
+			 * Ignore this value as well.
+			 */
+			if (data != 0 && data != svm->tsc_ratio_msr)
+				return 1;
+			break;
+		}
 
 		if (data & TSC_RATIO_RSVD)
 			return 1;



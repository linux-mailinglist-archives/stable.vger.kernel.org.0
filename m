Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3332163DFF0
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbiK3SwI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:52:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231573AbiK3Svy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:51:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A11563D48
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:51:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AABC4B81CAA
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:51:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08547C433C1;
        Wed, 30 Nov 2022 18:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834310;
        bh=pdTzps9UqRVl9daPs67KLsC1Lyk4trMv+f5paLHWHjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=thrhg+nvc9pPLWXfl0idO4rKxtwqDcFwDZqdwcIsx0Dj4JFUx0PXitfoi711bD+qc
         Hr8Q1opiO7Zd+dGW37JE2W/fWHatdDSlTmHN+LBsT4kQyWVS4iYm8euqlKu9T6rnNT
         Pk71WjVKzixRRB8BEIByDEmkzuP+HEtYS33f49tM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.0 207/289] KVM: x86: nSVM: leave nested mode on vCPU free
Date:   Wed, 30 Nov 2022 19:23:12 +0100
Message-Id: <20221130180548.812789144@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: Maxim Levitsky <mlevitsk@redhat.com>

commit 917401f26a6af5756d89b550a8e1bd50cf42b07e upstream.

If the VM was terminated while nested, we free the nested state
while the vCPU still is in nested mode.

Soon a warning will be added for this condition.

Cc: stable@vger.kernel.org
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20221103141351.50662-2-mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1440,6 +1440,7 @@ static void svm_vcpu_free(struct kvm_vcp
 	 */
 	svm_clear_current_vmcb(svm->vmcb);
 
+	svm_leave_nested(vcpu);
 	svm_free_nested(svm);
 
 	sev_free_vcpu(vcpu);



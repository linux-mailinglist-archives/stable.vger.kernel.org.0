Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 114416AF1BC
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233202AbjCGSrD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:47:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbjCGSqd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:46:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D7FCB5B54;
        Tue,  7 Mar 2023 10:35:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D61D9B819D1;
        Tue,  7 Mar 2023 18:35:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D5BC433D2;
        Tue,  7 Mar 2023 18:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214118;
        bh=+M1gEsg3qEIv515pBeyxMHFtrxXp6A5XzXwfNBlR9Zo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fp/4fAIPZV+hzE2P1sSMIf3fDMqXIYQqptrfj9+jdyZncb8uISz1afwNq5ihiR5Tn
         wAWsHdI36GaehkKFazNlHp9rr+jLW0Y38IaTJK39L0zJW9fH7t31LiytQ/g4UzfhJm
         tWrCYmFKZSsMzgsyTaNZzqICv6LApnf2y2MEbans=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andy Nguyen <theflow@google.com>,
        Thomas Lendacky <thomas.lendacky@amd.com>,
        Peter Gonda <pgonda@google.com>,
        David Rientjes <rientjes@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6.1 727/885] KVM: SVM: Fix potential overflow in SEVs send|receive_update_data()
Date:   Tue,  7 Mar 2023 18:01:01 +0100
Message-Id: <20230307170033.579012894@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Gonda <pgonda@google.com>

commit f94f053aa3a5d6ff17951870483d9eb9e13de2e2 upstream.

KVM_SEV_SEND_UPDATE_DATA and KVM_SEV_RECEIVE_UPDATE_DATA have an integer
overflow issue. Params.guest_len and offset are both 32 bits wide, with a
large params.guest_len the check to confirm a page boundary is not
crossed can falsely pass:

    /* Check if we are crossing the page boundary *
    offset = params.guest_uaddr & (PAGE_SIZE - 1);
    if ((params.guest_len + offset > PAGE_SIZE))

Add an additional check to confirm that params.guest_len itself is not
greater than PAGE_SIZE.

Note, this isn't a security concern as overflow can happen if and only if
params.guest_len is greater than 0xfffff000, and the FW spec says these
commands fail with lengths greater than 16KB, i.e. the PSP will detect
KVM's goof.

Fixes: 15fb7de1a7f5 ("KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA command")
Fixes: d3d1af85e2c7 ("KVM: SVM: Add KVM_SEND_UPDATE_DATA command")
Reported-by: Andy Nguyen <theflow@google.com>
Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org
Cc: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://lore.kernel.org/r/20230207171354.4012821-1-pgonda@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1293,7 +1293,7 @@ static int sev_send_update_data(struct k
 
 	/* Check if we are crossing the page boundary */
 	offset = params.guest_uaddr & (PAGE_SIZE - 1);
-	if ((params.guest_len + offset > PAGE_SIZE))
+	if (params.guest_len > PAGE_SIZE || (params.guest_len + offset) > PAGE_SIZE)
 		return -EINVAL;
 
 	/* Pin guest memory */
@@ -1473,7 +1473,7 @@ static int sev_receive_update_data(struc
 
 	/* Check if we are crossing the page boundary */
 	offset = params.guest_uaddr & (PAGE_SIZE - 1);
-	if ((params.guest_len + offset > PAGE_SIZE))
+	if (params.guest_len > PAGE_SIZE || (params.guest_len + offset) > PAGE_SIZE)
 		return -EINVAL;
 
 	hdr = psp_copy_user_blob(params.hdr_uaddr, params.hdr_len);



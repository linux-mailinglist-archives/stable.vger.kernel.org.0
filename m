Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC0581A7470
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 09:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406462AbgDNHOZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 03:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728832AbgDNHOX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 03:14:23 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D41C0A3BDC;
        Tue, 14 Apr 2020 00:14:23 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id j2so13057307wrs.9;
        Tue, 14 Apr 2020 00:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x3FALfbpRb/mq4e1FIFz0r4wYE516t5tOEUNmJGwv9Y=;
        b=sD8tioZTnhBcjH6L2+rSL824M7aZG9iTtB5irZ6xDl5XUn0TxsVCKoCocslJY9qk1D
         QUMK04ZbdzUmNcQzoOtjLIdr79Bl1NcrqAZKv0HGiiqk59o38mgIGikN1kyXzj9LGvUG
         trJwgn+POJ8cKzgV6MMcliH/+ppSqxW3VBTz7odbRm/Mz5/H6XJr11OACjSqYq0N/EUe
         +5Rz2nkXbFapvHFeLDujZZa1dG0p8nTphlDyR5lN5iNjBIwh+UONburm4Z9sy0FoE7ao
         mqlIxgyHkAwmwoKnQ+Lqujb3TGd1Ztk8Usm+HTO42iI5sUojF+m4gtHKeCRfRpFXhaRM
         IkTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x3FALfbpRb/mq4e1FIFz0r4wYE516t5tOEUNmJGwv9Y=;
        b=j+djeNDNXyOLwVOEmiaX9WzAVdNDSeaQ7HARkbmGxzkphFeHsMoj+R0CPTPYvzKOC6
         pi1/S55HNtkeG0OuQPnis98M5grvHC6COE+Jq9w1lby8UPRQFybuRx3HO0nLoMKQE7QG
         87sDlnsVlKskUdhmm+5PT3lxLejcAzmHw8dqnCKu2Juwp/mRMTKqEWtTjjuWmi5c2wt3
         gFG+88elbEpEMHldQBgGScwGwg8BqLw1kf4FWfUnnGSWVnjhfGqR+h0pWBAb//rkfuDU
         6VvIRh/BETIh1jIRTs9SAqy6q2WRPfMSoN884ifiSgghr6mO+uIjMES7H/uCHMMX3MNb
         h/uw==
X-Gm-Message-State: AGi0PuYh+/OqnDRh60ZxgcrL7mLmp2J3iq3Dcb6yNykNDcZi7zrOA3cz
        esQzqXd15IcojhWUc9SuhAQf9m3HX7w=
X-Google-Smtp-Source: APiQypLn3az45GzTgOtTi63CeNHJIlthS9496tL4dDm8jAxQNFlA0cvcDp1+Tt4vp5eZTg2jK1RKDg==
X-Received: by 2002:a5d:6885:: with SMTP id h5mr10120554wru.151.1586848461794;
        Tue, 14 Apr 2020 00:14:21 -0700 (PDT)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id a67sm18325900wmc.30.2020.04.14.00.14.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 00:14:21 -0700 (PDT)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] KVM: VMX: Enable machine check support for 32bit targets
Date:   Tue, 14 Apr 2020 09:14:14 +0200
Message-Id: <20200414071414.45636-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There is no reason to limit the use of do_machine_check
to 64bit targets. MCE handling works for both target familes.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: stable@vger.kernel.org
Fixes: a0861c02a981 ("KVM: Add VT-x machine check support")
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8959514eaf0f..01330096ff3e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4572,7 +4572,7 @@ static int handle_rmode_exception(struct kvm_vcpu *vcpu,
  */
 static void kvm_machine_check(void)
 {
-#if defined(CONFIG_X86_MCE) && defined(CONFIG_X86_64)
+#if defined(CONFIG_X86_MCE)
 	struct pt_regs regs = {
 		.cs = 3, /* Fake ring 3 no matter what the guest ran on */
 		.flags = X86_EFLAGS_IF,
-- 
2.25.2


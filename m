Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD03A74D75
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 13:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404298AbfGYLtm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 07:49:42 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39188 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404291AbfGYLtm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jul 2019 07:49:42 -0400
Received: by mail-wm1-f65.google.com with SMTP id u25so34099137wmc.4
        for <stable@vger.kernel.org>; Thu, 25 Jul 2019 04:49:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JwF4mpEiRa45bRWmG8LAm7NBwIkhh6yBccP7Pl5vh7Y=;
        b=V96k9xW7AMFocXboOhbbUoVkcEaZXeknqT+d1LHU7zi6xUTG8quZPwa3jNetRuXooU
         zvhjjGjrASel5i4iJZYyzyr0vZhecadWTV+Zdo0h8DvMh2d9o5q8aSzs8JvkbVXNzecC
         uCBG5yuBtBjweMC6284Mgn6CnBajQy7HoW/NU+oJXlI8521U7B48cWKF8rmfmVgfuRra
         HZKzOlmPbkZcwS4VO+5cTdbf5cDkIFMV7H2ewy9VbkbD43XVoOsJTrR0ZDahWSPOeRtb
         8JdBvy9bkwLnbdwjM5lbT+2rwbp7aEOtVEJlXxgPzucGayubR6b2j1ueVWRw2YUvUwKs
         HnoA==
X-Gm-Message-State: APjAAAX/nYI+B3gjFrzAKPncQU47Lv4rwMIcTv4kXbrj/e9spfd+kBNw
        SVs9wLQ1olE4Ck5duqXvBuAgNB5VYO0=
X-Google-Smtp-Source: APXvYqwHIAbuNzKH1sv37RyUICk9i11ATcpmEGDJP3UlsUFfAdbUyofZsSomxQmloUcfikdX/fDG7Q==
X-Received: by 2002:a05:600c:2245:: with SMTP id a5mr79165913wmm.121.1564055380779;
        Thu, 25 Jul 2019 04:49:40 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id t140sm44784683wmt.0.2019.07.25.04.49.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 25 Jul 2019 04:49:40 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     stable@vger.kernel.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH stable-5.1 0/3] KVM: x86: FPU and nested VMX guest reset fixes
Date:   Thu, 25 Jul 2019 13:49:35 +0200
Message-Id: <20190725114938.3976-1-vkuznets@redhat.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Few patches were recently marked for stable@ but commits are not
backportable as-is and require a few tweaks. Here is 5.1 stable backport.

[PATCH2 of the series applies as-is, I have it here for completeness]

Jan Kiszka (1):
  KVM: nVMX: Clear pending KVM_REQ_GET_VMCS12_PAGES when leaving nested

Paolo Bonzini (2):
  KVM: nVMX: do not use dangling shadow VMCS after guest reset
  Revert "kvm: x86: Use task structs fpu field for user"

 arch/x86/include/asm/kvm_host.h |  7 ++++---
 arch/x86/kvm/vmx/nested.c       | 10 +++++++++-
 arch/x86/kvm/x86.c              |  4 ++--
 3 files changed, 15 insertions(+), 6 deletions(-)

-- 
2.20.1


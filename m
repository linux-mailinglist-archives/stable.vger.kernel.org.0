Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6453961BB
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232488AbhEaOpj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:45:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231826AbhEaOnd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:43:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE29C6191D;
        Mon, 31 May 2021 13:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469263;
        bh=JUKEIcUfB95gMzsVG56H79iWc8ZzGhb934BU53z15Ho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VaUPte0NpvG5sAC0M879595AlIrh3CwZP5ZtCoN8pEERPpnkdnQkr2atL/bWcG+oU
         eryo8Vr6adiThXcrxOoRPdn0+hQhZk6dfmVOOZKeR29K3fP2tqZ+f1RJYW5B3KEL7A
         XsPHpf6ZSXBB2XrXAmB0lQF03oolIuR8DO/EIJgI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Richey <joerichey@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.12 130/296] KVM: X86: Use _BITUL() macro in UAPI headers
Date:   Mon, 31 May 2021 15:13:05 +0200
Message-Id: <20210531130708.263139199@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joe Richey <joerichey@google.com>

commit fb1070d18edb37daf3979662975bc54625a19953 upstream.

Replace BIT() in KVM's UPAI header with _BITUL(). BIT() is not defined
in the UAPI headers and its usage may cause userspace build errors.

Fixes: fb04a1eddb1a ("KVM: X86: Implement ring-based dirty memory tracking")
Signed-off-by: Joe Richey <joerichey@google.com>
Message-Id: <20210521085849.37676-3-joerichey94@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/kvm.h       |    5 +++--
 tools/include/uapi/linux/kvm.h |    5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -8,6 +8,7 @@
  * Note: you must update KVM_API_VERSION if you change this interface.
  */
 
+#include <linux/const.h>
 #include <linux/types.h>
 #include <linux/compiler.h>
 #include <linux/ioctl.h>
@@ -1834,8 +1835,8 @@ struct kvm_hyperv_eventfd {
  * conversion after harvesting an entry.  Also, it must not skip any
  * dirty bits, so that dirty bits are always harvested in sequence.
  */
-#define KVM_DIRTY_GFN_F_DIRTY           BIT(0)
-#define KVM_DIRTY_GFN_F_RESET           BIT(1)
+#define KVM_DIRTY_GFN_F_DIRTY           _BITUL(0)
+#define KVM_DIRTY_GFN_F_RESET           _BITUL(1)
 #define KVM_DIRTY_GFN_F_MASK            0x3
 
 /*
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -8,6 +8,7 @@
  * Note: you must update KVM_API_VERSION if you change this interface.
  */
 
+#include <linux/const.h>
 #include <linux/types.h>
 #include <linux/compiler.h>
 #include <linux/ioctl.h>
@@ -1834,8 +1835,8 @@ struct kvm_hyperv_eventfd {
  * conversion after harvesting an entry.  Also, it must not skip any
  * dirty bits, so that dirty bits are always harvested in sequence.
  */
-#define KVM_DIRTY_GFN_F_DIRTY           BIT(0)
-#define KVM_DIRTY_GFN_F_RESET           BIT(1)
+#define KVM_DIRTY_GFN_F_DIRTY           _BITUL(0)
+#define KVM_DIRTY_GFN_F_RESET           _BITUL(1)
 #define KVM_DIRTY_GFN_F_MASK            0x3
 
 /*



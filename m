Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E834B791F
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 14:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388660AbfISMQu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 08:16:50 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:34071 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388678AbfISMQu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Sep 2019 08:16:50 -0400
Received: by mail-ot1-f66.google.com with SMTP id m19so1021280otp.1
        for <stable@vger.kernel.org>; Thu, 19 Sep 2019 05:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=7095IBNZbxqf0SW8Bb1og7kWwYW4sLLVHeOG+Jux78U=;
        b=BO9d5dof1yDnksScdtdA7TRyV0c3kUVTOff1kiz5kc9Q6be5Iq2JNP+2UUmbAkiE7r
         pT3N8ofGMYjb6fzOXdxAv4PRMSEELEQcyDpxdLzJu9SyF9yzWPffSrLqtTQJ0hHueDfq
         3hnx8vLJ/pja3quAvNhXfINAJ6G8481c3QASujp9Lx/J0oVfquLmbeAFZTw1azJUOYmp
         tIeOY9Qss5cNw1745JuJ3Kwo3zWjLsFALlo0Qs2WBcDymN3AIf3cZuLdwhI6CLJ98hBX
         q+F1uRy4bDAjcdiCwBBHiQH0W2+NWPtElSYQ57Qzq9KzKWoXU8XAYlUgX3XpG3bqgt/F
         fPAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=7095IBNZbxqf0SW8Bb1og7kWwYW4sLLVHeOG+Jux78U=;
        b=C19NcEJTjJ7O+sR9xXpNYMPjldgSQgn89HiDxT/l/Or474lPmzDBVwJw8q8HTrNylA
         d/2GfTygHnqpGYazoLZXuf3wf97skek7D/9yDeb6Hu56VKeqeGjrCgN1bMSMQ18eTa2/
         pEiCYYcyh5IRiqjQlfyjbuBNFwb5+J21t5dA8oP07OOBvDNrp8q7UYM+Z+yQjTk6Cjij
         H6QlaeYDTMCNiKO1sRMrAKBlVXw9+FU1XuwNW83VTvGJx0XmVZ86UfYxpTm/UQUEhNeB
         Rgl8o/jlWeCb9TVx6+eX3hwMdgBgmzoyQkfKSGudBSiio9RSDmjnhRk8VJ8NDIx2WAh0
         mFHQ==
X-Gm-Message-State: APjAAAXclKDloLaOoA72xgwc+ac6GGqP85G1sq5nV1vufrkoYHirt3ik
        kDEXo9+o9n6MNKCF9/xc8shYAdM=
X-Google-Smtp-Source: APXvYqwHoxW1nYjjHUo2LPL6orgQo5K35ygg3BdvCA2TJuCOrLPnzAIxuzP4Ra2us1O3OZRMyc94aw==
X-Received: by 2002:a05:6830:15d9:: with SMTP id j25mr4770783otr.175.1568895409584;
        Thu, 19 Sep 2019 05:16:49 -0700 (PDT)
Received: from serve.minyard.net (serve.minyard.net. [2001:470:b8f6:1b::1])
        by smtp.gmail.com with ESMTPSA id t18sm2880187otd.60.2019.09.19.05.16.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Sep 2019 05:16:48 -0700 (PDT)
Received: from t560.minyard.net (unknown [192.168.27.180])
        by serve.minyard.net (Postfix) with ESMTP id 2DD031800CE;
        Thu, 19 Sep 2019 12:16:48 +0000 (UTC)
From:   minyard@acm.org
To:     stable@vger.kernel.org
Cc:     Corey Minyard <cminyard@mvista.com>
Subject: [PATCH] x86/boot: Add missing bootparam that breaks boot on some platforms
Date:   Thu, 19 Sep 2019 07:16:46 -0500
Message-Id: <20190919121646.22472-1-minyard@acm.org>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

Change

  a90118c445cc x86/boot: Save fields explicitly, zero out everything else

modified the way boot parameters were saved on x86.  When this was
backported, e820_table didn't exists, and that change was dropped.
Unfortunately, e820_table did exist, it was just named e820_map
in this kernel version.

This was breaking booting on a Supermicro Super Server/A2SDi-2C-HLN4F
with a Denverton CPU.  Adding e820_map to the saved boot params table
fixes the issue.

Cc: <stable@vger.kernel.org> # 4.9.x, 4.4.x
Signed-off-by: Corey Minyard <cminyard@mvista.com>
---
I checked the stable mailing lists and didn't see any discussion of
this, I hope it's not a dup, but some systems will be broken without
this.

I wasn't sure how to add a "Fixes:" field in a situation like this.

 arch/x86/include/asm/bootparam_utils.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/bootparam_utils.h b/arch/x86/include/asm/bootparam_utils.h
index 0232b5a2a2d9..588d8fbd1e6d 100644
--- a/arch/x86/include/asm/bootparam_utils.h
+++ b/arch/x86/include/asm/bootparam_utils.h
@@ -71,6 +71,7 @@ static void sanitize_boot_params(struct boot_params *boot_params)
 			BOOT_PARAM_PRESERVE(edd_mbr_sig_buf_entries),
 			BOOT_PARAM_PRESERVE(edd_mbr_sig_buffer),
 			BOOT_PARAM_PRESERVE(hdr),
+			BOOT_PARAM_PRESERVE(e820_map),
 			BOOT_PARAM_PRESERVE(eddbuf),
 		};
 
-- 
2.17.1


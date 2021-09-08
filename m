Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6B84037A9
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 12:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348332AbhIHKRD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 06:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231723AbhIHKRC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Sep 2021 06:17:02 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B63FC061575
        for <stable@vger.kernel.org>; Wed,  8 Sep 2021 03:15:55 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id g16so2467440wrb.3
        for <stable@vger.kernel.org>; Wed, 08 Sep 2021 03:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h3CEot+k+E816uF+Ji+0g1RbTFaJOMRVVgQ830Sms8c=;
        b=TSIb1v2+31IT+EWFlB+jzpTMDE58gKyRMLhv+zmTTIiMtlm2MbW3E8N8XM6PHNypGG
         TForSAlHqJ3PI5ye6ZE5QxtQvCx4LmkBPRhjU/8JfhV+Gs2MydUAxpB58BRA8poqHchs
         QVv/GZaQcoVlXQ/6BjwwPYw+0MM90DbZ/zBcNEhBtZuztuPCS3ev56/nmAHLnKsvvM26
         QpbKGbHl0CoeaB1JxY8Mvuoi/kkqAiF8TJfA4/D7uNSuJZwDnFCqq5UTB9A4ggYLXhx+
         uXz5IAH8cBcfeX55/f8vBVliglgcAl0L88sw12ZpqpH/QYdjDkV+X/G9ICRCJPjzL5bn
         zT+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h3CEot+k+E816uF+Ji+0g1RbTFaJOMRVVgQ830Sms8c=;
        b=I8P3aKSDEy2dLsGUt88dRyhutm4erivTlTfzhGxYS5tCYUtUSunwA1NOlJ2eLjdSvN
         miilffjMhiZFqKah9VSYTuljz0dEMFe7MaYaaNxGJc//r1dmwsxoDUZasYAlkmEXWuOu
         BTdaw5V5B8eV0Be3QK+3qXDSCNFzzxw6t0jPuFeu77d9TdMaar4LYG1PvMMcidQFYxAE
         5vDK/eQgipbmrtD60PThZFlcK3KcsqvaJH2tKeUhidYEQ0GTNDCnGmEYgpzpXrYE8YLQ
         43Odx2Wq+C3yZG5FwGViJ+Xwy7jAxjsyzJYIIhNDNYMENXAQQ9OLDtDNHTuE3nIrwSFr
         f9mw==
X-Gm-Message-State: AOAM530EiPSCffjlfxnSOOibrRMSavVqU5WpGS9kh6RY4HgMNSio7rT7
        C3WTu0AZF7YlcpekTgiqE4nE9R7kx0cejA==
X-Google-Smtp-Source: ABdhPJzH2xEKStYcGEbGwcctnOAVD6Pq7IBDIkitTTQdFwpFE0gBBFsIPgMRIUHc7PcepdOu1RC5fg==
X-Received: by 2002:adf:e74a:: with SMTP id c10mr3137541wrn.350.1631096153312;
        Wed, 08 Sep 2021 03:15:53 -0700 (PDT)
Received: from localhost.localdomain ([31.124.24.230])
        by smtp.gmail.com with ESMTPSA id t17sm1629553wra.95.2021.09.08.03.15.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 03:15:52 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Liu Jian <liujian56@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/1] igmp: Add ip_mc_list lock in ip_check_mc_rcu
Date:   Wed,  8 Sep 2021 11:15:34 +0100
Message-Id: <20210908101534.185105-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Jian <liujian56@huawei.com>

[ Upstream commit 23d2b94043ca8835bd1e67749020e839f396a1c2 ]

I got below panic when doing fuzz test:

Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 4056 Comm: syz-executor.3 Tainted: G    B             5.14.0-rc1-00195-gcff5c4254439-dirty #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
Call Trace:
dump_stack_lvl+0x7a/0x9b
panic+0x2cd/0x5af
end_report.cold+0x5a/0x5a
kasan_report+0xec/0x110
ip_check_mc_rcu+0x556/0x5d0
__mkroute_output+0x895/0x1740
ip_route_output_key_hash_rcu+0x2d0/0x1050
ip_route_output_key_hash+0x182/0x2e0
ip_route_output_flow+0x28/0x130
udp_sendmsg+0x165d/0x2280
udpv6_sendmsg+0x121e/0x24f0
inet6_sendmsg+0xf7/0x140
sock_sendmsg+0xe9/0x180
____sys_sendmsg+0x2b8/0x7a0
___sys_sendmsg+0xf0/0x160
__sys_sendmmsg+0x17e/0x3c0
__x64_sys_sendmmsg+0x9e/0x100
do_syscall_64+0x3b/0x90
entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x462eb9
Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8
 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48>
 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f3df5af1c58 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 000000000073bf00 RCX: 0000000000462eb9
RDX: 0000000000000312 RSI: 0000000020001700 RDI: 0000000000000007
RBP: 0000000000000004 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f3df5af26bc
R13: 00000000004c372d R14: 0000000000700b10 R15: 00000000ffffffff

It is one use-after-free in ip_check_mc_rcu.
In ip_mc_del_src, the ip_sf_list of pmc has been freed under pmc->lock protection.
But access to ip_sf_list in ip_check_mc_rcu is not protected by the lock.

Cc: <stable@vger.kernel.org> # 4.4+
Signed-off-by: Liu Jian <liujian56@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 net/ipv4/igmp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 00576bae183d3..0c321996c6eb0 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -2720,6 +2720,7 @@ int ip_check_mc_rcu(struct in_device *in_dev, __be32 mc_addr, __be32 src_addr, u
 		rv = 1;
 	} else if (im) {
 		if (src_addr) {
+			spin_lock_bh(&im->lock);
 			for (psf = im->sources; psf; psf = psf->sf_next) {
 				if (psf->sf_inaddr == src_addr)
 					break;
@@ -2730,6 +2731,7 @@ int ip_check_mc_rcu(struct in_device *in_dev, __be32 mc_addr, __be32 src_addr, u
 					im->sfcount[MCAST_EXCLUDE];
 			else
 				rv = im->sfcount[MCAST_EXCLUDE] != 0;
+			spin_unlock_bh(&im->lock);
 		} else
 			rv = 1; /* unspecified source; tentatively allow */
 	}
-- 
2.33.0.153.gba50c8fa24-goog


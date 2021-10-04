Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D07420C5C
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235084AbhJDNFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:05:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:39352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234980AbhJDNDe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:03:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B881361AF0;
        Mon,  4 Oct 2021 12:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352392;
        bh=cUTiwfggWkTkoBOnHrKaY3s6iBGG2/Iy51L4KfSG/gg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U3ro6X5/ztwcPAI21C0hkMCNxsxtSedy+qUMgWjnpDsSxK9bV9AmU26m2IEuDdcgC
         3YGbxkbblk3k1LHbXMbpXfJXiJP9mgCMMD8pgqilBhkec4G8jN6VydzDiba77tU5mA
         lgPu4CIJB71GEFst7vBLvOxizsyhllD2ArksC4Bs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Morse <james.morse@arm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 44/75] cpufreq: schedutil: Destroy mutex before kobject_put() frees the memory
Date:   Mon,  4 Oct 2021 14:52:19 +0200
Message-Id: <20211004125033.004279487@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125031.530773667@linuxfoundation.org>
References: <20211004125031.530773667@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

[ Upstream commit cdef1196608892b9a46caa5f2b64095a7f0be60c ]

Since commit e5c6b312ce3c ("cpufreq: schedutil: Use kobject release()
method to free sugov_tunables") kobject_put() has kfree()d the
attr_set before gov_attr_set_put() returns.

kobject_put() isn't the last user of attr_set in gov_attr_set_put(),
the subsequent mutex_destroy() triggers a use-after-free:
| BUG: KASAN: use-after-free in mutex_is_locked+0x20/0x60
| Read of size 8 at addr ffff000800ca4250 by task cpuhp/2/20
|
| CPU: 2 PID: 20 Comm: cpuhp/2 Not tainted 5.15.0-rc1 #12369
| Hardware name: ARM LTD ARM Juno Development Platform/ARM Juno Development
| Platform, BIOS EDK II Jul 30 2018
| Call trace:
|  dump_backtrace+0x0/0x380
|  show_stack+0x1c/0x30
|  dump_stack_lvl+0x8c/0xb8
|  print_address_description.constprop.0+0x74/0x2b8
|  kasan_report+0x1f4/0x210
|  kasan_check_range+0xfc/0x1a4
|  __kasan_check_read+0x38/0x60
|  mutex_is_locked+0x20/0x60
|  mutex_destroy+0x80/0x100
|  gov_attr_set_put+0xfc/0x150
|  sugov_exit+0x78/0x190
|  cpufreq_offline.isra.0+0x2c0/0x660
|  cpuhp_cpufreq_offline+0x14/0x24
|  cpuhp_invoke_callback+0x430/0x6d0
|  cpuhp_thread_fun+0x1b0/0x624
|  smpboot_thread_fn+0x5e0/0xa6c
|  kthread+0x3a0/0x450
|  ret_from_fork+0x10/0x20

Swap the order of the calls.

Fixes: e5c6b312ce3c ("cpufreq: schedutil: Use kobject release() method to free sugov_tunables")
Cc: 4.7+ <stable@vger.kernel.org> # 4.7+
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq_governor_attr_set.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq_governor_attr_set.c b/drivers/cpufreq/cpufreq_governor_attr_set.c
index 52841f807a7e..45fdf30cade3 100644
--- a/drivers/cpufreq/cpufreq_governor_attr_set.c
+++ b/drivers/cpufreq/cpufreq_governor_attr_set.c
@@ -77,8 +77,8 @@ unsigned int gov_attr_set_put(struct gov_attr_set *attr_set, struct list_head *l
 	if (count)
 		return count;
 
-	kobject_put(&attr_set->kobj);
 	mutex_destroy(&attr_set->update_lock);
+	kobject_put(&attr_set->kobj);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(gov_attr_set_put);
-- 
2.33.0




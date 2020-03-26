Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 234FB19362D
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 03:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727636AbgCZCvU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Mar 2020 22:51:20 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:34800 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727600AbgCZCvU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Mar 2020 22:51:20 -0400
Received: by mail-pj1-f66.google.com with SMTP id q16so2894979pje.1;
        Wed, 25 Mar 2020 19:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=igL6DNSPoj0Vd+3rnmZ1ATU2MAewKl3lRauvu90YjFc=;
        b=EhNyXOJtZJBINozD050ITWqUebkFSh+/1Pc5dAtnoLCpTZAyDgQ1B6FkQyzpVGgsv3
         lQkN7Ep6zXxkzUpzBreVdMGGKhL7sfbFQ3o1O5MvGa1wkYJhv2I2MZFLzwcS14lnfSPP
         OM9E95lNQy8zsOAbmCF+s4eb8wG8Lh8KXrRt0mkFfFhF6fVYTR/Nt2NVP+1ApXC0h+4B
         H2tlTa2aL0ZxV4cCCZzTr0YMk9mXvo6w4pB2eKRr8h8xiHcdWh52Yqi/nJoSqPj4GtoR
         E5GqbV36L91NAWkYJVRDtt2zawgnnYqM5gfwZ5p7ZoBVBS09GdwxUi838DQXKIDOHjtN
         jbCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=igL6DNSPoj0Vd+3rnmZ1ATU2MAewKl3lRauvu90YjFc=;
        b=X2cg7qi1XSBqdc73sVvSBe0uKo+TOAhHNxNkzmFweaAuEIPPGgrL0G4KeSzkzT7DjG
         oTmU26BUbpMgB+p4SKfHH4S1QlCgvpwMZ+wRpt+sK7NIXebpaVxUteJXOIcS5ft3QLj+
         fsml7kcYn7pEkQB//of8fG4oU3Sk5lu6Um//tRomiIjhduGh42fNl8zDuJ8FThLYtYet
         IndrJF51RQXPMuFRIHp1vYKoASsgJrQr/KQCgBfGlNSRDjf7rl5G5eibqJzeyxmYbTVm
         QvPGhp2UCKjfItLaBI2X1N+IhR/hc9XPR6NQdU34TQCN/ZDAlOF8jnjffQsWTO0hAhe9
         fOoQ==
X-Gm-Message-State: ANhLgQ2HkJN9xC04UNX1K9yMHC4o0wa2GqZoNUg4KkMzA8AWJQ2n3l3c
        if8BLfZKJkPJACDmwaKmTVM=
X-Google-Smtp-Source: ADFU+vugEpysstLmXUtexy5TL0tcEq5GVSyeLoJH2VZstNoq4RQ699Uifam3hHfGzRi377sbuz0Hxg==
X-Received: by 2002:a17:90a:276e:: with SMTP id o101mr683369pje.104.1585191078590;
        Wed, 25 Mar 2020 19:51:18 -0700 (PDT)
Received: from dev.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id f45sm466200pjg.29.2020.03.25.19.51.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Mar 2020 19:51:17 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     bsingharora@gmail.com, akpm@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH] kernel/taskstats: fix wrong nla type for {cgroup,task}stats policy
Date:   Wed, 25 Mar 2020 22:50:42 -0400
Message-Id: <1585191042-9935-1-git-send-email-laoar.shao@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

After our server is upgraded to a newer kernel, we found that it
continuesly print a warning in the kernel message. The warning is,
[832984.946322] netlink: 'irmas.lc': attribute type 1 has an invalid length.

irmas.lc is one of our container monitor daemons, and it will use
CGROUPSTATS_CMD_GET to get the cgroupstats, that is similar with
tools/accounting/getdelays.c. We can also produce this warning with
getdelays. For example, after running bellow command
	$ ./getdelays -C /sys/fs/cgroup/memory
then you can find a warning in dmesg,
[61607.229318] netlink: 'getdelays': attribute type 1 has an invalid length.

This warning is introduced in commit 6e237d099fac ("netlink: Relax attr
validation for fixed length types"), which is used to check whether
attributes using types NLA_U* and NLA_S* have an exact length.

Regarding this issue, the root cause is cgroupstats_cmd_get_policy defines
a wrong type as NLA_U32, while it should be NLA_NESTED an its minimal
length is NLA_HDRLEN. That is similar to taskstats_cmd_get_policy.

As this behavior change really breaks our application, we'd better
cc stable as well.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: stable@vger.kernel.org
---
 kernel/taskstats.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index e2ac0e3..b90a520 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -35,8 +35,8 @@
 static struct genl_family family;
 
 static const struct nla_policy taskstats_cmd_get_policy[TASKSTATS_CMD_ATTR_MAX+1] = {
-	[TASKSTATS_CMD_ATTR_PID]  = { .type = NLA_U32 },
-	[TASKSTATS_CMD_ATTR_TGID] = { .type = NLA_U32 },
+	[TASKSTATS_CMD_ATTR_PID]  = { .type = NLA_NESTED },
+	[TASKSTATS_CMD_ATTR_TGID] = { .type = NLA_NESTED },
 	[TASKSTATS_CMD_ATTR_REGISTER_CPUMASK] = { .type = NLA_STRING },
 	[TASKSTATS_CMD_ATTR_DEREGISTER_CPUMASK] = { .type = NLA_STRING },};
 
@@ -45,7 +45,7 @@
  * Make sure they are always aligned.
  */
 static const struct nla_policy cgroupstats_cmd_get_policy[TASKSTATS_CMD_ATTR_MAX+1] = {
-	[CGROUPSTATS_CMD_ATTR_FD] = { .type = NLA_U32 },
+	[CGROUPSTATS_CMD_ATTR_FD] = { .type = NLA_NESTED },
 };
 
 struct listener {
-- 
1.8.3.1


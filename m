Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B86E647E36
	for <lists+stable@lfdr.de>; Fri,  9 Dec 2022 08:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbiLIHER (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Dec 2022 02:04:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbiLIHDt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Dec 2022 02:03:49 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A04E3123D;
        Thu,  8 Dec 2022 23:00:37 -0800 (PST)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NT22S406bz15NGX;
        Fri,  9 Dec 2022 14:59:44 +0800 (CST)
Received: from [10.67.110.173] (10.67.110.173) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 9 Dec 2022 15:00:35 +0800
Message-ID: <389334fe-6e12-96b2-6ce9-9f0e8fcb85bf@huawei.com>
Date:   Fri, 9 Dec 2022 15:00:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Content-Language: en-US
From:   "Guozihua (Scott)" <guozihua@huawei.com>
Subject: [RFC] IMA LSM based rule race condition issue on 4.19 LTS
To:     Mimi Zohar <zohar@linux.ibm.com>, <dmitry.kasatkin@gmail.com>,
        Paul Moore <paul@paul-moore.com>, <sds@tycho.nsa.gov>,
        <eparis@parisplace.org>, Greg KH <gregkh@linuxfoundation.org>,
        <sashal@kernel.org>
CC:     <selinux@vger.kernel.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.173]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi community.

Previously our team reported a race condition in IMA relates to LSM 
based rules which would case IMA to match files that should be filtered 
out under normal condition. The issue was originally analyzed and fixed 
on mainstream. The patch and the discussion could be found here: 
https://lore.kernel.org/all/20220921125804.59490-1-guozihua@huawei.com/

After that, we did a regression test on 4.19 LTS and the same issue 
arises. Further analysis reveled that the issue is from a completely 
different cause.

The cause is that selinux_audit_rule_init() would set the rule (which is 
a second level pointer) to NULL immediately after called. The relevant 
codes are as shown:

security/selinux/ss/services.c:
> int selinux_audit_rule_init(u32 field, u32 op, char *rulestr, void **vrule)
> {
>         struct selinux_state *state = &selinux_state;
>         struct policydb *policydb = &state->ss->policydb;
>         struct selinux_audit_rule *tmprule;
>         struct role_datum *roledatum;
>         struct type_datum *typedatum;
>         struct user_datum *userdatum;
>         struct selinux_audit_rule **rule = (struct selinux_audit_rule **)vrule;
>         int rc = 0;
> 
>         *rule = NULL;
*rule is set to NULL here, which means the rule on IMA side is also NULL.
> 
>         if (!state->initialized)
>                 return -EOPNOTSUPP;
...
> out:
>         read_unlock(&state->ss->policy_rwlock);
> 
>         if (rc) {
>                 selinux_audit_rule_free(tmprule);
>                 tmprule = NULL;
>         }
> 
>         *rule = tmprule;
rule is updated at the end of the function.
> 
>         return rc;
> }

security/integrity/ima/ima_policy.c:
> static bool ima_match_rules(struct ima_rule_entry *rule, struct inode *inode,
>                             const struct cred *cred, u32 secid,
>                             enum ima_hooks func, int mask)
> {...
> for (i = 0; i < MAX_LSM_RULES; i++) {
>                 int rc = 0;
>                 u32 osid;
>                 int retried = 0;
> 
>                 if (!rule->lsm[i].rule)
>                         continue;
Setting rule to NULL would lead to LSM based rule matching being skipped.
> retry:
>                 switch (i) {

To solve this issue, there are multiple approaches we might take and I 
would like some input from the community.

The first proposed solution would be to change 
selinux_audit_rule_init(). Remove the set to NULL bit and update the 
rule pointer with cmpxchg.

> diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
> index a9f2bc8443bd..aa74b04ccaf7 100644
> --- a/security/selinux/ss/services.c
> +++ b/security/selinux/ss/services.c
> @@ -3297,10 +3297,9 @@ int selinux_audit_rule_init(u32 field, u32 op, char *rulestr, void **vrule)
>         struct type_datum *typedatum;
>         struct user_datum *userdatum;
>         struct selinux_audit_rule **rule = (struct selinux_audit_rule **)vrule;
> +       struct selinux_audit_rule *orig = rule;
>         int rc = 0;
>  
> -       *rule = NULL;
> -
>         if (!state->initialized)
>                 return -EOPNOTSUPP;
>  
> @@ -3382,7 +3381,8 @@ int selinux_audit_rule_init(u32 field, u32 op, char *rulestr, void **vrule)
>                 tmprule = NULL;
>         }
>  
> -       *rule = tmprule;
> +       if (cmpxchg(rule, orig, tmprule) != orig)
> +               selinux_audit_rule_free(tmprule);
>  
>         return rc;
>  }

This solution would be an easy fix, but might influence other modules 
calling selinux_audit_rule_init() directly or indirectly (on 4.19 LTS, 
only auditfilter and IMA it seems). And it might be worth returning an 
error code such as -EAGAIN.

Or, we can access rules via RCU, similar to what we do on 5.10. This 
could means more code change and testing.

Reported-by: Huaxin Lu <luhuaxin1@huawei.com>
-- 
Best
GUO Zihua

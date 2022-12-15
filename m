Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEA0764D80A
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 09:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiLOIvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 03:51:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiLOIvQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 03:51:16 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4BF21D64D;
        Thu, 15 Dec 2022 00:51:14 -0800 (PST)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NXmC90TWszmWfr;
        Thu, 15 Dec 2022 16:50:13 +0800 (CST)
Received: from [10.67.110.173] (10.67.110.173) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Thu, 15 Dec 2022 16:51:13 +0800
Message-ID: <fffb29b7-a1ac-33fb-6aca-989e5567f565@huawei.com>
Date:   Thu, 15 Dec 2022 16:51:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [RFC] IMA LSM based rule race condition issue on 4.19 LTS
Content-Language: en-US
To:     Mimi Zohar <zohar@linux.ibm.com>, <dmitry.kasatkin@gmail.com>,
        Paul Moore <paul@paul-moore.com>, <sds@tycho.nsa.gov>,
        <eparis@parisplace.org>, Greg KH <gregkh@linuxfoundation.org>,
        <sashal@kernel.org>
CC:     <selinux@vger.kernel.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <389334fe-6e12-96b2-6ce9-9f0e8fcb85bf@huawei.com>
 <efd4ce83299a10b02b1c04cc94934b8d51969e1c.camel@linux.ibm.com>
 <6a5bc829-b788-5742-cbfc-dba348065dbe@huawei.com>
 <566721e9e8d639c82d841edef4d11d30a4d29694.camel@linux.ibm.com>
From:   "Guozihua (Scott)" <guozihua@huawei.com>
In-Reply-To: <566721e9e8d639c82d841edef4d11d30a4d29694.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.173]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/12/14 20:19, Mimi Zohar wrote:
> On Wed, 2022-12-14 at 09:33 +0800, Guozihua (Scott) wrote:
>> On 2022/12/13 23:30, Mimi Zohar wrote:
>>> On Fri, 2022-12-09 at 15:00 +0800, Guozihua (Scott) wrote:
>>>> Hi community.
>>>>
>>>> Previously our team reported a race condition in IMA relates to LSM 
>>>> based rules which would case IMA to match files that should be filtered 
>>>> out under normal condition. The issue was originally analyzed and fixed 
>>>> on mainstream. The patch and the discussion could be found here: 
>>>> https://lore.kernel.org/all/20220921125804.59490-1-guozihua@huawei.com/
>>>>
>>>> After that, we did a regression test on 4.19 LTS and the same issue 
>>>> arises. Further analysis reveled that the issue is from a completely 
>>>> different cause.
>>>>
>>>> The cause is that selinux_audit_rule_init() would set the rule (which is 
>>>> a second level pointer) to NULL immediately after called. The relevant 
>>>> codes are as shown:
>>>>
>>>> security/selinux/ss/services.c:
>>>>> int selinux_audit_rule_init(u32 field, u32 op, char *rulestr, void **vrule)
>>>>> {
>>>>>         struct selinux_state *state = &selinux_state;
>>>>>         struct policydb *policydb = &state->ss->policydb;
>>>>>         struct selinux_audit_rule *tmprule;
>>>>>         struct role_datum *roledatum;
>>>>>         struct type_datum *typedatum;
>>>>>         struct user_datum *userdatum;
>>>>>         struct selinux_audit_rule **rule = (struct selinux_audit_rule **)vrule;
>>>>>         int rc = 0;
>>>>>
>>>>>         *rule = NULL;
>>>> *rule is set to NULL here, which means the rule on IMA side is also NULL.
>>>>>
>>>>>         if (!state->initialized)
>>>>>                 return -EOPNOTSUPP;
>>>> ...
>>>>> out:
>>>>>         read_unlock(&state->ss->policy_rwlock);
>>>>>
>>>>>         if (rc) {
>>>>>                 selinux_audit_rule_free(tmprule);
>>>>>                 tmprule = NULL;
>>>>>         }
>>>>>
>>>>>         *rule = tmprule;
>>>> rule is updated at the end of the function.
>>>>>
>>>>>         return rc;
>>>>> }
>>>>
>>>> security/integrity/ima/ima_policy.c:
>>>>> static bool ima_match_rules(struct ima_rule_entry *rule, struct inode *inode,
>>>>>                             const struct cred *cred, u32 secid,
>>>>>                             enum ima_hooks func, int mask)
>>>>> {...
>>>>> for (i = 0; i < MAX_LSM_RULES; i++) {
>>>>>                 int rc = 0;
>>>>>                 u32 osid;
>>>>>                 int retried = 0;
>>>>>
>>>>>                 if (!rule->lsm[i].rule)
>>>>>                         continue;
>>>> Setting rule to NULL would lead to LSM based rule matching being skipped.
>>>>> retry:
>>>>>                 switch (i) {
>>>>
>>>> To solve this issue, there are multiple approaches we might take and I 
>>>> would like some input from the community.
>>>>
>>>> The first proposed solution would be to change 
>>>> selinux_audit_rule_init(). Remove the set to NULL bit and update the 
>>>> rule pointer with cmpxchg.
>>>>
>>>>> diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
>>>>> index a9f2bc8443bd..aa74b04ccaf7 100644
>>>>> --- a/security/selinux/ss/services.c
>>>>> +++ b/security/selinux/ss/services.c
>>>>> @@ -3297,10 +3297,9 @@ int selinux_audit_rule_init(u32 field, u32 op, char *rulestr, void **vrule)
>>>>>         struct type_datum *typedatum;
>>>>>         struct user_datum *userdatum;
>>>>>         struct selinux_audit_rule **rule = (struct selinux_audit_rule **)vrule;
>>>>> +       struct selinux_audit_rule *orig = rule;
>>>>>         int rc = 0;
>>>>>  
>>>>> -       *rule = NULL;
>>>>> -
>>>>>         if (!state->initialized)
>>>>>                 return -EOPNOTSUPP;
>>>>>  
>>>>> @@ -3382,7 +3381,8 @@ int selinux_audit_rule_init(u32 field, u32 op, char *rulestr, void **vrule)
>>>>>                 tmprule = NULL;
>>>>>         }
>>>>>  
>>>>> -       *rule = tmprule;
>>>>> +       if (cmpxchg(rule, orig, tmprule) != orig)
>>>>> +               selinux_audit_rule_free(tmprule);
>>>>>  
>>>>>         return rc;
>>>>>  }
>>>>
>>>> This solution would be an easy fix, but might influence other modules 
>>>> calling selinux_audit_rule_init() directly or indirectly (on 4.19 LTS, 
>>>> only auditfilter and IMA it seems). And it might be worth returning an 
>>>> error code such as -EAGAIN.
>>>>
>>>> Or, we can access rules via RCU, similar to what we do on 5.10. This 
>>>> could means more code change and testing.
>>>
>>> In the 4.19 kernel, IMA is doing a lazy LSM based policy rule update as
>>> needed.  IMA waits for selinux_audit_rule_init() to complete and
>>> shouldn't see NULL, unless there is an SELinux failure.  Before
>>> "fixing" the problem, what exactly is the problem?
>>
>> IMA runs on multiple cores. On 4.19 kernel, IMA do a lazy update on ALL
>> LSM based rules in one go without using RCU, which would still allow
>> other cores to access the rule being updated. And that's the issue.
>>
>> An example scenario would be:
>> 	CPU1			|	CPU2
>> opened a file and starts	|
>> updating LSM based rules.	|
>> 				| opened a file and starts
>> 				| matching rules.
>> 				|
>> set a LSM based rule to NULL.	| access the same LSM based rule and
>>  				| see that it's NULL.
>>
>> In this situation, CPU 2 would recognize this rule as not LSM based and
>> ignore the LSM part of the rule while matching.
> 
> Would picking up just ima_lsm_update_rule(), without changing to the
> lsm policy update notifier, from upstream and calling it from
> ima_lsm_update_rules() resolve the RCU locking issue?  Or are there
> other issues?

Hi Mimi,

That should resolve the issue just fine. However, that'd mean having a
customized ima_lsm_update_rules as well as a customized
ima_lsm_update_rule functions on 4.19.y, potentially decrease the
maintainability. The customization of the two functions mentioned above
would be to ripoff the RCU part so that we can leave the other rule-list
access untouched.

-- 
Best
GUO Zihua


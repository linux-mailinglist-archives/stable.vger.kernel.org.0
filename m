Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08F58388E8B
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 15:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353482AbhESNDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 09:03:37 -0400
Received: from mail-dm6nam10on2055.outbound.protection.outlook.com ([40.107.93.55]:6733
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240957AbhESNDg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 May 2021 09:03:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Acd4cNA2oRUfd/1rKjNHXJU0amoOljeTHqkbeVaPUCWLCy/BAvNxkZNf2RO1HJ834Vgwih0zHLWcU+GZBMsYYGHKOtj2Pr+YJfeOWpwBlrUNIhd1rAJfPYaAO7NABl5LuD4w3uaP3ExtH7TnPnLcSil3TivnJp8eVqwY57DPPrcPWfsju8mA01XQmsuLYFgZgriPZtzLQ3D4vW9mgtBF1UHWQSNV7src89iiJ8pj76rBO3TQYAhbj6kap0N+l7hcXIOk6Uph77O7LJ6hVEzShk/WaAU11xbWT2xWw8OWTSNG4fSxkkiSEkOAssxy2+dIDZG4PhJb/coXafYmANvonQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KVF0ZVmIhHmxxAwdzSFAMG5ppj0kQxEd+CPr4teGSEk=;
 b=fM7XGm3ngV61wXUubR3ZTs5dq4PXR1TA1eoD3JfIzEWa036NUGgv/LpPAhJh7GvaOTnuJPGPBU7DVhjlsrrfS8zaRH5KGG4hNIK9QED5Q3quw1NSEjWdS8luGPh0TuIMjRQLSyxQAH4DV05iQIndnb4TICHfEuaAf36QefzrfJ4plJgYh1PsVvd4rd1zQ/v4Z0aNIfpHE7L8KHfzkue4Zeuf9tYIgQcp/pIGiLA8kMw0gURa7Dj9+wHotzO21xc1ILqSE6xqARyp6ERWXYuduXIfAcrDZ4zbdI4NGfKJvCsHnQDkcDqxSlBGI8JUA4QJ64UiZqc9eWsReXVR1zyshw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KVF0ZVmIhHmxxAwdzSFAMG5ppj0kQxEd+CPr4teGSEk=;
 b=F2Iq1+dNX/3YbYCfom4m44IoA5DXt1ujpSO4JI8UCahCeeE3jdWPktxqF3cyww6zW6RraU370+DsbRqYKb/Y+49x9PtFULudrT2jwA5botGBlhU3AMVHGYc4/l36J+mR7hhzmk0vo0zBtaUo9K43+mgSdt8k9siVk84uN471LHk3jW0y9t+0JZCX6NrFS4uAoRdW1pgvoU9YfyIVyIk2G9fQ1HMm6tenww3DA8LjlJ06SxJzG3NzzdaXvDfbVlBFmziR0VHQDYTAljicCVNiIEqVQiYUBm/+qHZ79qHm8aeLz9cSeTI/59Nzeh+Nx+zS1E8fAlLIhqCCKVFUSJAHXw==
Authentication-Results: de.ibm.com; dkim=none (message not signed)
 header.d=none;de.ibm.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB2582.namprd12.prod.outlook.com (2603:10b6:4:b5::37) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.32; Wed, 19 May
 2021 13:02:16 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::ddb4:2cbb:4589:f039]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::ddb4:2cbb:4589:f039%4]) with mapi id 15.20.4129.033; Wed, 19 May 2021
 13:02:16 +0000
Date:   Wed, 19 May 2021 10:02:14 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, pasic@linux.vnet.ibm.com, jjherne@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        stable@vger.kernel.org, Tony Krowiak <akrowiak@stny.rr.com>
Subject: Re: [PATCH v2] s390/vfio-ap: fix memory leak in mdev remove callback
Message-ID: <20210519130214.GI1002214@nvidia.com>
References: <594374f6-8cf6-4c22-0bac-3b224c55bbb6@linux.ibm.com>
 <20210517211030.368ca64b.pasic@linux.ibm.com>
 <966a60ad-bdde-68d0-ae2f-06121c6ad970@de.ibm.com>
 <9ebd5fd8-b093-e5bc-e680-88fa7a9b085c@linux.ibm.com>
 <494af62b-dc9a-ef2c-1869-d8f5ed239504@de.ibm.com>
 <20210518173351.39646b45.pasic@linux.ibm.com>
 <ca5f1c72-09a3-d270-44a0-bda54c554f67@de.ibm.com>
 <20210519012709.3bcc30e7.pasic@linux.ibm.com>
 <250189ed-bded-5261-d8f3-f75787be7aeb@de.ibm.com>
 <9c2b4711-5a26-15b0-8651-67a88bf12270@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9c2b4711-5a26-15b0-8651-67a88bf12270@de.ibm.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR16CA0039.namprd16.prod.outlook.com
 (2603:10b6:208:234::8) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR16CA0039.namprd16.prod.outlook.com (2603:10b6:208:234::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25 via Frontend Transport; Wed, 19 May 2021 13:02:15 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1ljLq2-00AhhG-Nv; Wed, 19 May 2021 10:02:14 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a4f3489-e85a-4389-923e-08d91ac6538e
X-MS-TrafficTypeDiagnostic: DM5PR12MB2582:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB2582E8D9D67AF7482C700586C22B9@DM5PR12MB2582.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mbdl4El7dfoK4uZfkycyV9iKWDOvOB6I+hDhW8uyMlAHnGHA/us0zbOQ86z6DLEiHOSbK5oingFwvPFrWj2yu5HhqsGK9YhV00L4yuO5fdmQwwLZqgtvlM1T+uk/RFht+1QWHhyA9wzyAAtlrgA2LBR8RMeuDlFRMiLSPifLXVbgvi46y/w0MUawMDUg+qxuAfrx4iqfCUwfO4oXGlXyS/uI/jsf0oqrwfa5y8KuOL9Gg1vvMHpjEWcZH6pBMmD25Yu9Oao0Y+tyvgDaJuJLCLPa500enUQTKxrCHsh1U3cXZ/29d2oQ49EYU0TMdoy1Ei4ZxlVwlq2O0kZRvf8x3dSw1wPPLz0PdIneqjvGR4o07TIba17Gpqk0SeQsxr3d/w/y9W5myZVAWCG0i4frnV/VU63gA9UcxGuqyy8yPMY3fh1CNzPXuM8oa/Vt3wvmUvugpgkHi8h8vAod8jG457l/jd7D8E61r2iBbzf8m3MJCzbsZDgzO0ZOKrtt5iNJmkK+WF4SAcPWIGN8ldQud8gkUe9p7A2VMWedrEJ3yCxP5taUDGtXcHB2/r8i+3KwWv8oOZUc48Bfqyn5faSg28WFkH3tXIzJuz/DVrYy8rg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(39860400002)(346002)(136003)(7416002)(316002)(83380400001)(38100700002)(2616005)(4326008)(426003)(86362001)(66946007)(2906002)(66476007)(33656002)(478600001)(6916009)(36756003)(54906003)(186003)(5660300002)(66556008)(26005)(53546011)(8936002)(8676002)(9786002)(9746002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?b3BpZ3VVRUVpbE1mMytabFU3UDhvaXFPRFZ1SUxYYTFOOUQwZHp0WnJleThx?=
 =?utf-8?B?LzBQWG1Pa2lrZGE3QkV5RVIwSlVIeEpSREp0aWRMOWNMR2lGcHZRWHloVlVP?=
 =?utf-8?B?MVRGTERxNVZPM2Uwam80Y0JMUklwQnIrc0U2b2FCaFBEaDVocWhZRkdYSUh1?=
 =?utf-8?B?SytEeVd6WGgzRXRSRmNUNXc0Y3czdm9xZkczazZiTXZZZW9ZbU14V1EwZmx0?=
 =?utf-8?B?Rm94NzJXWlI4QnM2UXd0YmlhNHFVdGxIbkk2SEE3UjVYVFN2QVNOVFBsamxW?=
 =?utf-8?B?MXhvZHIzenlYMzBzc254TzUydkUvcjJKWGVrWnpGMjg0c3VYSml0OWtUOEFS?=
 =?utf-8?B?cHRzK25OYjdhemg5YW1BMTFGN0tzOHRUQVhpYjhBWjM0czdUNnU4MWkvNnhp?=
 =?utf-8?B?SWlabWlZV2JQQi9VZzk5UGxnQ3lVbXFjWkVEa0tjYjZkTEQvbFllaS9OZTRu?=
 =?utf-8?B?a20xeHRGWjlSTy9jUW1JZzhKZitUZU5QN1NPeEdTY1lCOTdGZFFhN1RZZzlz?=
 =?utf-8?B?anhEQVpoakNibWpRaUtjc1QxR3hhRGVFaFEraENFM3BnNk5DZDkwTjJKYjhk?=
 =?utf-8?B?akVZYkcwOU00T2thUDhFMzI0bTBCRTdua0VZVWZzUG0vS3VtMmUyeWVaNDhk?=
 =?utf-8?B?NzlOalhkellaeDVBSmFYR2tLRmhoZFJiUzFFU21DMlpqUlYvbCtEMDh5VXFM?=
 =?utf-8?B?Ti9zbFY1bjMxQVFxUWhINnpYTHE5eVRqV0hKcTVITW5UdmdHYWF4cGlaZDBJ?=
 =?utf-8?B?Q1p3TW16WkxvRTQ1KzdGVkNUR1hoZVp4TTVHZHYvNnhNc0lKbE00WGJ1WEwv?=
 =?utf-8?B?QS9uZnJPOXBJaDZoOU5qaEZPWVlhcnVmWnZhQmYvVXdjUkl1YmZBKzhlaXZw?=
 =?utf-8?B?UUpCdDdFMmhkaUdtaUpXMXZROHZvSzF6S2JMUERGZjVIb1ByK2pPREtXbVN0?=
 =?utf-8?B?VlVYL0xsSTNwVjVRK3VINmxqa3JyMlA0elM1R0F4dGNBMVA5RXBmdm11ZUhx?=
 =?utf-8?B?ZlNWRC9FMVdhZGxRZzU1amg2bVd2MXB1NUlMWnE2R3E3eERreVVUMi9XU25r?=
 =?utf-8?B?VnlBei84YmdlV1BDdHYvQWN6eUdRNlFTZHlpaUdxZzdReG10ZmYwQ2xWOGpN?=
 =?utf-8?B?cGZYb093UXlYdm5laUpqbXVaMGd1TDdLQnhYVDI2aFpBdGNOZWlzUHpISTVp?=
 =?utf-8?B?ck44WFRCaGtVbHpYMkRRUjlIaVhGSHNSeC9TRHFwMnBaNWdVSVAyNXFRaU5V?=
 =?utf-8?B?QzMzKzVOZGJVSHBpYTc1aUpOemxGMEhkZFk4Ui83T2xPM05ET3RsQ1o1TmVj?=
 =?utf-8?B?L09la29iNFFkaVhCL3p0MGlTWXovQWNNeWVabS9weC9scnNDNStlV205VDNC?=
 =?utf-8?B?c0oxVHhwempjaTFvZllYQXVSZ0p5dEcyN2RQTkxLY3dDOG5tT2R6K1hrSjVz?=
 =?utf-8?B?YzdsVklHRUw1UDVEeHJabDJHY0lzKzc4WnBSeXlBbDhnZEVkd1dXeWhsbnMz?=
 =?utf-8?B?N1c4SnBjZFp5VXFyUm14NysvTjB3Ymk2R0FHeGRXZ3p1bzNvTDBweXZaSkxu?=
 =?utf-8?B?NDU3bGY3SWpGUVRkUW5LU0tGS3pCaTN6bTdQNzc0OHdEQmRkNlY1NjRqbTJR?=
 =?utf-8?B?ODNNbmFUQk1EazFTWGVNdGMyQzFlMWw1RGl6WUFKZUZMSTEvM1VpS2JqWFQx?=
 =?utf-8?B?Q28xWkFKSWFkY2VSdkdFQWU3TG5HSFFYa1N1RjNkMWI1V0xGUzNZUHNHWENl?=
 =?utf-8?Q?2H98U3MWJFZ3YDjcNHov/Cyaa/5SAXvQJO768XQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a4f3489-e85a-4389-923e-08d91ac6538e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2021 13:02:15.8684
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tFGGQsn2/PcNRFlJrIzpdB97x1/yV9cJT+hK7d6WgwcDdaZLbh7ZZVWv5j/qH5PT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2582
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 19, 2021 at 01:22:56PM +0200, Christian Borntraeger wrote:
> 
> 
> On 19.05.21 10:17, Christian Borntraeger wrote:
> > 
> > 
> > On 19.05.21 01:27, Halil Pasic wrote:
> > > On Tue, 18 May 2021 19:01:42 +0200
> > > Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> > > 
> > > > On 18.05.21 17:33, Halil Pasic wrote:
> > > > > On Tue, 18 May 2021 15:59:36 +0200
> > > > > Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> > > [..]
> > > > > > > > 
> > > > > > > > Would it help, if the code in priv.c would read the hook once
> > > > > > > > and then only work on the copy? We could protect that with rcu
> > > > > > > > and do a synchronize rcu in vfio_ap_mdev_unset_kvm after
> > > > > > > > unsetting the pointer?
> > > > > 
> > > > > Unfortunately just "the hook" is ambiguous in this context. We
> > > > > have kvm->arch.crypto.pqap_hook that is supposed to point to
> > > > > a struct kvm_s390_module_hook member of struct ap_matrix_mdev
> > > > > which is also called pqap_hook. And struct kvm_s390_module_hook
> > > > > has function pointer member named "hook".
> > > > 
> > > > I was referring to the full struct.
> > > > > > > 
> > > > > > > I'll look into this.
> > > > > > 
> > > > > > I think it could work. in priv.c use rcu_readlock, save the
> > > > > > pointer, do the check and call, call rcu_read_unlock.
> > > > > > In vfio_ap use rcu_assign_pointer to set the pointer and
> > > > > > after setting it to zero call sychronize_rcu.
> > > > > 
> > > > > In my opinion, we should make the accesses to the
> > > > > kvm->arch.crypto.pqap_hook pointer properly synchronized. I'm
> > > > > not sure if that is what you are proposing. How do we usually
> > > > > do synchronisation on the stuff that lives in kvm->arch?
> > > > 
> > > > RCU is a method of synchronization. We  make sure that structure
> > > > pqap_hook is still valid as long as we are inside the rcu read
> > > > lock. So the idea is: clear pointer, wait until all old readers
> > > > have finished and the proceed with getting rid of the structure.
> > > 
> > > Yes I know that RCU is a method of synchronization, but I'm not
> > > very familiar with it. I'm a little confused by "read the hook
> > > once and then work on a copy". I guess, I would have to read up
> > > on the RCU again to get clarity. I intend to brush up my RCU knowledge
> > > once the patch comes along. I would be glad to have your help when
> > > reviewing an RCU based solution for this.
> > 
> > Just had a quick look. Its not trivial, as the hook function itself
> > takes a mutex and an rcu section must not sleep. Will have a deeper
> > look.
> 
> 
> As a quick hack something like this could work. The whole locking is pretty
> complicated and this makes it even more complex so we might want to do
> a cleanup/locking rework later on.
> 
> 
> index 9928f785c677..fde6e02aab54 100644
> +++ b/arch/s390/kvm/priv.c
> @@ -609,6 +609,7 @@ static int handle_io_inst(struct kvm_vcpu *vcpu)
>   */
>  static int handle_pqap(struct kvm_vcpu *vcpu)
>  {
> +       struct kvm_s390_module_hook *pqap_hook;
>         struct ap_queue_status status = {};
>         unsigned long reg0;
>         int ret;
> @@ -657,14 +658,21 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
>          * Verify that the hook callback is registered, lock the owner
>          * and call the hook.
>          */
> -       if (vcpu->kvm->arch.crypto.pqap_hook) {
> -               if (!try_module_get(vcpu->kvm->arch.crypto.pqap_hook->owner))
> +       rcu_read_lock();
> +       pqap_hook = rcu_dereference(vcpu->kvm->arch.crypto.pqap_hook);
> +       if (pqap_hook) {
> +               if (!try_module_get(pqap_hook->owner)) {

module locking doesn't prevent driver unbinding

> +                       rcu_read_unlock();
>                         return -EOPNOTSUPP;
> -               ret = vcpu->kvm->arch.crypto.pqap_hook->hook(vcpu);
> -               module_put(vcpu->kvm->arch.crypto.pqap_hook->owner);
> +               }
> +               rcu_read_unlock();
> +               ret = pqap_hook->hook(vcpu);

So taking the pointer out of the rcu still isn't protected.

Unless this is super performance critical just use a rw sem

Jason

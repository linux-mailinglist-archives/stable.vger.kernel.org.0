Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9F0E42A14C
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 11:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235699AbhJLJn7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 05:43:59 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:8808 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235687AbhJLJn7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 05:43:59 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19C9NUuW017600;
        Tue, 12 Oct 2021 09:41:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=xRd/SmtCU4CB5sYP8IkF+uibD5Tet7jRIdHiGXGAePg=;
 b=YXrxl14alUt9CuXTZDtuPYVXkMFewws2hVMMY3Qek8rj4xdd71rbnJ4R2Dt/Ckd2sbiD
 8djYnRqY8mq5Ge5ftiIXb2se4Z5E/wq13T3yuOmHwqZ+36zZw8w7dZGgSvUzSlkrigsv
 xPR5hUkqRCszfHp25LmcJVhQT5oe8881SQWy4J0hU9KixU0h36refR9Ggm5UIZrwWxZV
 9pvQvpye26CUq0nCSp/ZG/0q7nPjMEsVuhYO9iflwGxxxAcqvX6qd8aipPVL9WveM95O
 4qgQgsUc2PBn10pgNDpyXCwvsSLTTwNj8PZrGyriQJ8rsEut5fMnYuMg8WAjJRiJrUVL NA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bmtmk4pqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 09:41:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19C9ZJDs030613;
        Tue, 12 Oct 2021 09:41:27 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by userp3020.oracle.com with ESMTP id 3bkyv9ucup-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 09:41:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UxRiPrutkcqVF4LPksajYahMGPevEQKraWtEH0QynehFbZieuoOfqCeHO8R1J+laFIgyxhEbWHROXUvWuJHVhEbgDyE/A5hb9Oq37zggN1sD/aW4mgAxoTibWWsDzK5+5CjhRAwL6rDXC1u4kxXqEaO5M5TyQSjf4s715fh0VGogpMeZOC+IjvebxTf9g59S9Jka59rZCCc0aI7K+O1hDAw7rzOiX496CnkeUVXF3y2/2o0u1i1FsZpiPyBxOp7Qesnf3/FfRvaN+uwOIJwfrH0e7vXR48pjbZ9c5ubVQ1F/7wcUBKWUyMJlRcYRC4x6b/Uda9aU60+KPf90M/mb2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xRd/SmtCU4CB5sYP8IkF+uibD5Tet7jRIdHiGXGAePg=;
 b=CZP9MAlQa1eC5i93RRg/K31gzOybqZBLJ7ZWKC4foeZw2Jhb90mAC6rcnn6VymcxPm7PscijmqeR3Sw1IDR1kgzo+Ewem0C/zkkmuApqSKLvCDVR9VvStxp1eTZTMUmiXQDo0SHZzQ7jPfmVyclYofwjEW0Rr/vCpHONZuogxy68KMAxl1M4JDSGUfCzSOcc8PUMUaJufEqZJNIuKrGMAFiyLOSMdr5bcuch6GCyHE08xt0f3gDm904SQwpecY/lWgC9uq6Ul1jw0FjeUZXnOX9MAzldDjqcmJdi3tdgdTi6t3hwdcUWdRL9iq3RuJiD1yR3nH8XOj/pGu9w5sm0Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xRd/SmtCU4CB5sYP8IkF+uibD5Tet7jRIdHiGXGAePg=;
 b=UqVWedQB6jWU5tA67C8kE5sGxTGYI5rxt21EbN0m4GV0JU7B7qlGHimQr07yM9spz3ErVYkDKK9guGv/uEN8T8R7k0hiiQGWNpfQGNrHc0cUhLzPV35Wd/DF4cDxphdshsrZ6xZR+w53ZNAlFuvKuMx6PiWbwCY60PVaB9A78zE=
Authentication-Results: schaufler-ca.com; dkim=none (message not signed)
 header.d=none;schaufler-ca.com; dmarc=none action=none
 header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1485.namprd10.prod.outlook.com
 (2603:10b6:300:25::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Tue, 12 Oct
 2021 09:41:25 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 09:41:25 +0000
Date:   Tue, 12 Oct 2021 12:41:01 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     Paul Moore <paul@paul-moore.com>, Todd Kjos <tkjos@google.com>,
        zohar@linux.ibm.com, arve@android.com, joel@joelfernandes.org,
        devel@driverdev.osuosl.org,
        Jeffrey Vander Stoep <jeffv@google.com>,
        James Morris <jmorris@namei.org>, kernel-team@android.com,
        tkjos@android.com, keescook@chromium.org, jannh@google.com,
        selinux@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        maco@android.com, christian@brauner.io, gregkh@linuxfoundation.org,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH v4 2/3] binder: use cred instead of task for getsecid
Message-ID: <20211012094101.GE8429@kadam>
References: <20211007004629.1113572-1-tkjos@google.com>
 <20211007004629.1113572-3-tkjos@google.com>
 <CAHC9VhSDnwapGk6Pvn5iuKv0zCtZSbfnGAkZwKcxVYLVRH6CLg@mail.gmail.com>
 <8c07f9b7-58b8-18b5-84f8-9b6c78acb08b@schaufler-ca.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c07f9b7-58b8-18b5-84f8-9b6c78acb08b@schaufler-ca.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0018.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::30)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (62.8.83.99) by JNXP275CA0018.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.24 via Frontend Transport; Tue, 12 Oct 2021 09:41:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0bb7a870-095e-4dd1-4c04-08d98d6474c1
X-MS-TrafficTypeDiagnostic: MWHPR10MB1485:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1485FBDF8509C5B43F4896D18EB69@MWHPR10MB1485.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qb6uopPr2uc0VR2Wws/Y1pkhxOg8WoRZlx7xbuLkYoQ/lRyQoKfVuhgVN646gRFIKMFO9BG5pADznMFwSG3CuzMAS7yIQoy5Wk0DCmQ6DWFdQXGb9eKyk3Jzs2McuXNnsqXJ5duzrXQMM8VEYjL+eszPxXHH1oDLpkIOJ3TzysajVf0QJRZXaVVx214vxHUJ2y/3Sj23qBybo5m02GckjEg/L3PWrSyer9Bh/TSibDo2qch72BCBE2KkeegsCLnnTvW/pX/0qARun7EL9SJfx9kIJU9pBItNKs5gzt1msuDoHIVdWzR8o7diXwWRWyJ9jW03A+8P4BwhAXANj5EaYZOxBtLAUcmHVLgr5BPMoKZlxX6KoO/qPEhF733W9eNDgKuPvhe3SsCKnIEGQ+Xb0QEyr358FIfdPQGl49819cMJkrDyTASjqzp0PBa0Eta/zyBreE3XVZaw4+/8qn/9FNYZfKFXzlZnI059hhAg8aK1NZLO5VV2ePcUX98XLJLU6zi2VjWNOyarBNVwF/mCobNCwEOn12Ak/jg3zO5FIDMZDnOnVfTC6fkH8maVYhjuPHGIMLBghIvVsb2VsUAdPdAyjGcuWZYxUNYwnP5wH9TJdrhx1REBEKQzrQ+OPkUy00+uSosEKGT69gLJPyAFJvb3Evis+HNswWiScN75/LtFxrRCJwdeosqZ0qOxq+CSaXKswRvfRLT2VilxHX420g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(9686003)(66946007)(53546011)(6496006)(508600001)(4326008)(66476007)(66556008)(7416002)(52116002)(55016002)(186003)(26005)(8936002)(8676002)(33716001)(1076003)(316002)(54906003)(6666004)(5660300002)(9576002)(956004)(6916009)(33656002)(2906002)(86362001)(83380400001)(44832011)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7IKkuEvMpNfWN31RlCmw0c95ZmzYALPSlsKEN6K5nXoaHCJOJMvj4ILwVUHc?=
 =?us-ascii?Q?CmAhU8/U88QMEyPsGTXogmc4l2gRYDQ62w/WNZ+QijpfLcmt0mvrD8J3EEN4?=
 =?us-ascii?Q?AEXT93f5bg1jBe/XOa5var9jxljKyJHFqvfqm3v3Ir6OnJFp/9kAKH+X9DHV?=
 =?us-ascii?Q?5hBZ4eYm2AabwUpesei7ZqenactaV+EwGOfcJooTccDjpx2tzaVxVm3/FlZD?=
 =?us-ascii?Q?778LQCs7NXDwZfiS7FkxJk7Q62/X57dJkr/D8JvNW3XO4er9tINXZGcxMLJo?=
 =?us-ascii?Q?SJgfwWrtvp0uiBsUgDmfWfG8eSrLhOI2Iw3IErZBJyKJIEftRnumPplfPipU?=
 =?us-ascii?Q?lupbRny8Yb2zCEhv3dtnjelPHSsikGA37DzGNGvD5saiJwDtpm507hbKE4D7?=
 =?us-ascii?Q?xHKnGiKY9D9N6bDqqFkH5uglxophw9XlEfYcKtkowvEx+4Bhe1dvKA+OS46r?=
 =?us-ascii?Q?S2uXqRz9s+ZWYD+TZUM+beUK89Y+9ls6LIkM1SjcXvylIaXEYB2mlkU/k9O2?=
 =?us-ascii?Q?kzE11ZRYl64xJlN6TWqUsZ3FiGTkA3bur1fU0eHmp7VkAjWXHGWVjr0R2Qeg?=
 =?us-ascii?Q?oUHpcS9lDvVBgSDAtbf0q83qUBSsK+XnIWFvAEhAjtkvQjxGYPdU1JymLVvy?=
 =?us-ascii?Q?K1FX9OBghG/CE3GnrTcdmfAoRDtDgPfSYCA9Ew5ps2G3C4C6XQmP72GNnRm5?=
 =?us-ascii?Q?KaQyPCkqowA9b9IqhUyQczSt9CB9iQ7utfWqyDYoYhAGvC/hPhAst7qUvVf1?=
 =?us-ascii?Q?YHLz8dPSoOrFtkGMjYyl5Um+dCTLI1KWlGVON59tnuBOOtj6u4HVJEeT7IHr?=
 =?us-ascii?Q?0M8rYx2NX2EGeEiKxpSUkqrKs5E4w3qNISSbAYOKP5Hj/idcjQq/VQOm2sRr?=
 =?us-ascii?Q?jTm36YgiOhSJln1alX9ivecmUot27cr5rW13a/Uc9pNSa9ySoqyqYQuHTjYD?=
 =?us-ascii?Q?3xsrCgjcgIwBzavOm5n24ar/JglEqy6wq0MtsgZUqnPxd2012+9BmBLCuT11?=
 =?us-ascii?Q?o0VSu8kpk54Ic7wKGMWvJHrxm7stpWfQkh16Ez0iB/tnNm2hzOES6y+FEjrs?=
 =?us-ascii?Q?a6TZheka8u/3oNgZNEmleg2v5rEZNj3KpcPDrJ8E5LFLThNY00JvVIzU8CX2?=
 =?us-ascii?Q?eK1nhTjXJqTVWlMkArs3fbCFCMb+xrD0eLnYu7/F4by4iBHZSUdRQ7NAtD4n?=
 =?us-ascii?Q?1dRbVQ2eJRiErQikKToA38IzKoRETTzkIg9xqBtspW4Yy2nP/BW8EuEbsbz2?=
 =?us-ascii?Q?du4pRvK8xC9g+J4SRMcM7o6qDS8Q53H+UiTRxNWmbDR6+dooeK+SmHfjnbsr?=
 =?us-ascii?Q?rEoaRxe0JmbwsEpu7Hw3fZCe?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bb7a870-095e-4dd1-4c04-08d98d6474c1
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 09:41:24.9334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +WmhxGUjERlROeSM2yyPJMIvoqWLfD54dVpzO9Nuq/jRbWgAZsEOU+7OLaIXNK6Kz0FsSDnnVH3gbrTmOgYlFw/bdQ/8SXnASiJBEk2fwTI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1485
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10134 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110120054
X-Proofpoint-GUID: JTU0P7iOClnRDJtKii4-54icXUWo52Io
X-Proofpoint-ORIG-GUID: JTU0P7iOClnRDJtKii4-54icXUWo52Io
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 11, 2021 at 02:59:13PM -0700, Casey Schaufler wrote:
> On 10/11/2021 2:33 PM, Paul Moore wrote:
> > On Wed, Oct 6, 2021 at 8:46 PM Todd Kjos <tkjos@google.com> wrote:
> >> Use the 'struct cred' saved at binder_open() to lookup
> >> the security ID via security_cred_getsecid(). This
> >> ensures that the security context that opened binder
> >> is the one used to generate the secctx.
> >>
> >> Fixes: ec74136ded79 ("binder: create node flag to request sender's
> >> security context")
> >> Signed-off-by: Todd Kjos <tkjos@google.com>
> >> Suggested-by: Stephen Smalley <stephen.smalley.work@gmail.com>
> >> Reported-by: kernel test robot <lkp@intel.com>
> >> Cc: stable@vger.kernel.org # 5.4+
> >> ---
> >> v3: added this patch to series
> >> v4: fix build-break for !CONFIG_SECURITY
> >>
> >>  drivers/android/binder.c | 11 +----------
> >>  include/linux/security.h |  4 ++++
> >>  2 files changed, 5 insertions(+), 10 deletions(-)
> >>
> >> diff --git a/drivers/android/binder.c b/drivers/android/binder.c
> >> index ca599ebdea4a..989afd0804ca 100644
> >> --- a/drivers/android/binder.c
> >> +++ b/drivers/android/binder.c
> >> @@ -2722,16 +2722,7 @@ static void binder_transaction(struct binder_proc *proc,
> >>                 u32 secid;
> >>                 size_t added_size;
> >>
> >> -               /*
> >> -                * Arguably this should be the task's subjective LSM secid but
> >> -                * we can't reliably access the subjective creds of a task
> >> -                * other than our own so we must use the objective creds, which
> >> -                * are safe to access.  The downside is that if a task is
> >> -                * temporarily overriding it's creds it will not be reflected
> >> -                * here; however, it isn't clear that binder would handle that
> >> -                * case well anyway.
> >> -                */
> >> -               security_task_getsecid_obj(proc->tsk, &secid);
> >> +               security_cred_getsecid(proc->cred, &secid);
> >>                 ret = security_secid_to_secctx(secid, &secctx, &secctx_sz);
> >>                 if (ret) {
> >>                         return_error = BR_FAILED_REPLY;
> >> diff --git a/include/linux/security.h b/include/linux/security.h
> >> index 6344d3362df7..f02cc0211b10 100644
> >> --- a/include/linux/security.h
> >> +++ b/include/linux/security.h
> >> @@ -1041,6 +1041,10 @@ static inline void security_transfer_creds(struct cred *new,
> >>  {
> >>  }
> >>
> >> +static inline void security_cred_getsecid(const struct cred *c, u32 *secid)
> >> +{
> >> +}
> > Since security_cred_getsecid() doesn't return an error code we should
> > probably set the secid to 0 in this case, for example:
> >
> >   static inline void security_cred_getsecid(...)
> >   {
> >     *secid = 0;
> >   }
> 
> If CONFIG_SECURITY is unset there shouldn't be any case where
> the secid value is ever used for anything. Are you suggesting that
> it be set out of an abundance of caution?

The security_secid_to_secctx() function is probably inlined so probably
KMSan will not warn about this.  But Smatch will warn about passing
unitialized variables.  You probably wouldn't recieve and email about
it, and I would just add an exception that security_cred_getsecid()
should be ignored.

regards,
dan carpenter


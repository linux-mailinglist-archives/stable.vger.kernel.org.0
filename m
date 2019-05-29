Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2641D2E3EB
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 19:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725956AbfE2RwM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 13:52:12 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47646 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbfE2RwM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 May 2019 13:52:12 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4THn2m6013274;
        Wed, 29 May 2019 17:52:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=zS7nhDY8zD6uO1Hi0MnWsHWn6OOdXraZj2olnu9zxQA=;
 b=jilOCIZFH3nHVfqt+6p/eIEQPixKu46WU0IxvRxRQ4s2up0sJ62qMDZ6Bcc/vLzqIfLN
 bs5tlBNO+mp3xpHwLBlKCR2R16oTM0JngA5IOIq0k2te74Uo/+/CP5miEhBVX7VaQFXi
 qM9WDjIDrgqgAxB/yF4DhdboI8Ad1ZnWjJjAaNHjm4eIqrNoQV3PNFUwFwirU0+4hOTo
 bUWQ520yBG8EH7CQoGaXjtsOj1fsV9AoSAXFWtpJjNaorZTEhR/dWUVld5d5ySpckGc8
 rm3TfhjsNWlbZZW5/fRXqE5eHXsuPZtcXPceP9XflE1vKApUQOvU8SjjqXSfyWnkIjyk RA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2spw4tkjrd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 May 2019 17:52:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4THoN1G133442;
        Wed, 29 May 2019 17:52:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 2sqh73uwm2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 29 May 2019 17:52:00 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x4THpx4m136610;
        Wed, 29 May 2019 17:51:59 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2sqh73uwku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 May 2019 17:51:59 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4THpwCW013446;
        Wed, 29 May 2019 17:51:58 GMT
Received: from wengwanwork.cn.oracle.com (/10.211.52.31)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 May 2019 10:51:57 -0700
Subject: Re: [PATCH v4] fs/ocfs2: fix race in ocfs2_dentry_attach_lock
To:     ocfs2-devel@oss.oracle.com
Cc:     gechangwei@live.cn, daniel.sobe@nxp.com, akpm@linux-foundation.org,
        stable@vger.kernel.org, jiangqi903@gmail.com
References: <20190529174636.22364-1-wen.gang.wang@oracle.com>
From:   Wengang <wen.gang.wang@oracle.com>
Message-ID: <85299b01-b9c3-81a1-d37b-bd06d701a8af@oracle.com>
Date:   Wed, 29 May 2019 10:51:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20190529174636.22364-1-wen.gang.wang@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9272 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=62 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905290116
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

This is a minor change from v3. It returns in place when racing is detected.

Changwei and Daniel,

I added your Reviewed-by and/or Tested-by with the patch, if you don't 
think it's good, pls let me know.

thanks,
wengang


On 05/29/2019 10:46 AM, Wengang Wang wrote:
> ocfs2_dentry_attach_lock() can be executed in parallel threads against the
> same dentry. Make that race safe.
> The race is like this:
>
>              thread A                               thread B
>
> (A1) enter ocfs2_dentry_attach_lock,
> seeing dentry->d_fsdata is NULL,
> and no alias found by
> ocfs2_find_local_alias, so kmalloc
> a new ocfs2_dentry_lock structure
> to local variable "dl", dl1
>
>                 .....
>
>                                      (B1) enter ocfs2_dentry_attach_lock,
>                                      seeing dentry->d_fsdata is NULL,
>                                      and no alias found by
>                                      ocfs2_find_local_alias so kmalloc
>                                      a new ocfs2_dentry_lock structure
>                                      to local variable "dl", dl2.
>
>                                                     ......
>
> (A2) set dentry->d_fsdata with dl1,
> call ocfs2_dentry_lock() and increase
> dl1->dl_lockres.l_ro_holders to 1 on
> success.
>                ......
>
>                                      (B2) set dentry->d_fsdata with dl2
>                                      call ocfs2_dentry_lock() and increase
> 				    dl2->dl_lockres.l_ro_holders to 1 on
> 				    success.
>
>                                                    ......
>
> (A3) call ocfs2_dentry_unlock()
> and decrease
> dl2->dl_lockres.l_ro_holders to 0
> on success.
>               ....
>
>                                      (B3) call ocfs2_dentry_unlock(),
>                                      decreasing
> 				    dl2->dl_lockres.l_ro_holders, but
> 				    see it's zero now, panic
>
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> Reported-by: Daniel Sobe <daniel.sobe@nxp.com>
> Tested-by: Daniel Sobe <daniel.sobe@nxp.com>
> Reviewed-by: Changwei Ge <gechangwei@live.cn>
> ---
> v4: return in place on race detection.
>
> v3: add Reviewed-by, Reported-by and Tested-by only
>
> v2: 1) removed lock on dentry_attach_lock at the first access of
>         dentry->d_fsdata since it helps very little.
>      2) do cleanups before freeing the duplicated dl
>      3) return after freeing the duplicated dl found.
> ---
>
>   fs/ocfs2/dcache.c | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
>
> diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
> index 290373024d9d..e8ace3b54e9c 100644
> --- a/fs/ocfs2/dcache.c
> +++ b/fs/ocfs2/dcache.c
> @@ -310,6 +310,18 @@ int ocfs2_dentry_attach_lock(struct dentry *dentry,
>   
>   out_attach:
>   	spin_lock(&dentry_attach_lock);
> +	if (unlikely(dentry->d_fsdata && !alias)) {
> +		/* d_fsdata is set by a racing thread which is doing
> +		 * the same thing as this thread is doing. Leave the racing
> +		 * thread going ahead and we return here.
> +		 */
> +		spin_unlock(&dentry_attach_lock);
> +		iput(dl->dl_inode);
> +		ocfs2_lock_res_free(&dl->dl_lockres);
> +		kfree(dl);
> +		return 0;
> +	}
> +
>   	dentry->d_fsdata = dl;
>   	dl->dl_count++;
>   	spin_unlock(&dentry_attach_lock);


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E094FC9D42
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 13:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729989AbfJCL3T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 07:29:19 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40344 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729987AbfJCL3T (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 07:29:19 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x93BOXrg118476;
        Thu, 3 Oct 2019 11:29:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=CnArpqQ0Rg86nep6PgSTZTPcjNou0Dx3xNTIU3N4RW0=;
 b=R8oBbguKb9HH+FJsc0weUTXxVabu6g/gMGHG2TsQ5MbZoZ5VnMLRinuu4UjP+mp+9wgv
 9ePY/deQpLu0fMa6eENgKbDqX/y7RV6pKk8YbWr9NSG/GXomy4X/pMPXFPNbiZN6h1BU
 eDMRWffWunuuvzntI/ePdlg1pFIhAmIMayPMIkYbfFMqOLXKDoUO3zymgXXIlXrJRYD3
 rr7uRABrt17e86Rn4OHOhSJk24XDOi4LYOe3K6Dl59ObIicI6oEF05NYEv2PlIdN4Uah
 Hzm8bBva0cPM6tqUyWr6BPqxRMafUHAW5NtNuMsDHbFdl+XWJ8yb2ld5AhExQmytvJBl Mw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2va05s3599-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Oct 2019 11:29:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x93BOAC7184398;
        Thu, 3 Oct 2019 11:27:13 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2vcg63ej5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Oct 2019 11:27:13 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x93BRCqm002795;
        Thu, 3 Oct 2019 11:27:12 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Oct 2019 04:27:12 -0700
Date:   Thu, 3 Oct 2019 14:26:50 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Denis Efremov <efremov@linux.com>
Cc:     devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] staging: wlan-ng: fix uninitialized variable
Message-ID: <20191003112649.GR22609@kadam>
References: <20191002174103.1274-1-efremov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191002174103.1274-1-efremov@linux.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9398 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910030107
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9398 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910030107
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 02, 2019 at 08:41:03PM +0300, Denis Efremov wrote:
> The result variable in prism2_connect() can be used uninitialized on path
> !channel --> ... --> is_wep --> sme->key --> sme->key_idx >= NUM_WEPKEYS.
> This patch initializes result with 0.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Denis Efremov <efremov@linux.com>
> ---
>  drivers/staging/wlan-ng/cfg80211.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/wlan-ng/cfg80211.c b/drivers/staging/wlan-ng/cfg80211.c
> index eee1998c4b18..d426905e187e 100644
> --- a/drivers/staging/wlan-ng/cfg80211.c
> +++ b/drivers/staging/wlan-ng/cfg80211.c
> @@ -441,7 +441,7 @@ static int prism2_connect(struct wiphy *wiphy, struct net_device *dev,
>  	int chan = -1;
>  	int is_wep = (sme->crypto.cipher_group == WLAN_CIPHER_SUITE_WEP40) ||
>  	    (sme->crypto.cipher_group == WLAN_CIPHER_SUITE_WEP104);
> -	int result;
> +	int result = 0;
>  	int err = 0;
>  

I can't see any reason why we should have both "err" and "result".
Maybe in olden times "result" used to save positive error codes instead
of negative error codes but now it's just negatives and zero on success.
There is no reason for the exit label either, we could just return
directly.

So could you redo it and get rid of "result" entirely?  Otherwise it
just causes more bugs like this.

regards,
dan carpenter


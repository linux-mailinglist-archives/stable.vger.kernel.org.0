Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9FE30675
	for <lists+stable@lfdr.de>; Fri, 31 May 2019 04:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfEaCDv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 22:03:51 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58422 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726372AbfEaCDv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 22:03:51 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4V1xA9N115851;
        Fri, 31 May 2019 02:02:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=rwKPrHhAqsnF3IC8rHR9oGZY6hOFmYqa6o4xSYJTwto=;
 b=F8ZHY1944PxCs9qrrjyGPSNDbAGdH8FOwppLPtyqnugsq4CC7V+CGolotza4GNK3YRRg
 o69LUya5vuTfaqLTR46D0NjxFNst7S7iBd3zJg1Fr7SUfszGMPZe1VnTq9TJNi/ySouJ
 LQGrG2oQjsklnk0rIGz0RXt4/j2KkaCPCAyKe6T4BVds67JdATMwzTLyClnaSHndRYJi
 5A9C5koUDbsOe4/oIbnCIzIwyQApC83w2Z3aSBZO0L9zU7j/Nd8QwllSr0oOif7LfrTb
 IH5JuYpnqM/OuicnZf7wvPF158psgS2CBtpsajqN8CfDPH15VFYXEKFImXGRCc3n1n4X 1w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2spw4tugjp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 May 2019 02:02:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4V2201q103943;
        Fri, 31 May 2019 02:02:37 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2srbdyas48-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 May 2019 02:02:37 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4V22aIX027037;
        Fri, 31 May 2019 02:02:36 GMT
Received: from dhcp-10-159-147-224.vpn.oracle.com (/10.159.147.224)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 May 2019 19:02:36 -0700
Subject: Re: [stable] xen/pciback: Don't disable PCI_COMMAND on PCI device
 reset.
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Prarit Bhargava <prarit@redhat.com>,
        Juergen Gross <jgross@suse.com>,
        xen-devel@lists.xenproject.org, stable <stable@vger.kernel.org>
References: <1559229415.24330.2.camel@codethink.co.uk>
From:   Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Organization: Oracle Corporation
Message-ID: <0e6ebb5c-ff43-6d65-bcba-6ac5e60aa472@oracle.com>
Date:   Thu, 30 May 2019 19:02:34 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:52.0)
 Gecko/20100101 Thunderbird/52.6.0
MIME-Version: 1.0
In-Reply-To: <1559229415.24330.2.camel@codethink.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9273 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905310010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9273 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905310010
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/30/19 8:16 AM, Ben Hutchings wrote:
> I'm looking at CVE-2015-8553 which is fixed by:
> 
> commit 7681f31ec9cdacab4fd10570be924f2cef6669ba
> Author: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Date:   Wed Feb 13 18:21:31 2019 -0500
> 
>      xen/pciback: Don't disable PCI_COMMAND on PCI device reset.
> 
> I'm aware that this change is incompatible with qemu < 2.5, but that's
> now quite old.  Do you think it makes sense to apply this change to
> some stable branches?
> 
> Ben.
> 

Hey Ben,

<shrugs> My opinion is to drop it, but if Juergen thinks it makes sense 
to backport I am not going to argue.

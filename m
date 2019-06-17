Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4D2348BF7
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 20:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725764AbfFQSeW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 14:34:22 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56206 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726088AbfFQSeV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jun 2019 14:34:21 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5HIW4Te089999
        for <stable@vger.kernel.org>; Mon, 17 Jun 2019 14:34:21 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t6d0yghns-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Mon, 17 Jun 2019 14:34:20 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <zohar@linux.ibm.com>;
        Mon, 17 Jun 2019 19:34:18 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 17 Jun 2019 19:34:16 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5HIYFYW59572340
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jun 2019 18:34:15 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE26BAE057;
        Mon, 17 Jun 2019 18:34:14 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3586BAE04D;
        Mon, 17 Jun 2019 18:34:13 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.81.90])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 Jun 2019 18:34:13 +0000 (GMT)
Subject: Re: [PATCH] firmware: improve LSM/IMA security behaviour
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Sven Van Asbroeck <thesven73@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>
Cc:     Stable <stable@vger.kernel.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        linux-kernel@vger.kernel.org
Date:   Mon, 17 Jun 2019 14:34:02 -0400
In-Reply-To: <20190617182354.10846-1-TheSven73@gmail.com>
References: <20190617182354.10846-1-TheSven73@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19061718-0016-0000-0000-00000289E1A1
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061718-0017-0000-0000-000032E72CDD
Message-Id: <1560796442.4072.170.camel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-17_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=897 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906170164
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2019-06-17 at 14:23 -0400, Sven Van Asbroeck wrote:
> The firmware loader queries if LSM/IMA permits it to load firmware
> via the sysfs fallback. Unfortunately, the code does the opposite:
> it expressly permits sysfs fw loading if security_kernel_load_data(
> LOADING_FIRMWARE) returns -EACCES. This happens because a
> zero-on-success return value is cast to a bool that's true on success.
> 
> Fix the return value handling so we get the correct behaviour.

Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>


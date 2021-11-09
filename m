Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A921449FF5
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 01:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235868AbhKIAwb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 19:52:31 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:42814 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235850AbhKIAwa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Nov 2021 19:52:30 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1A8I0K1A011746;
        Mon, 8 Nov 2021 16:49:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0220; bh=Ly3oDC5BauenDJ6aZ3RGgF7++ooIQx/3RQ/9PYdZY+s=;
 b=EQ3BiUqgfsch/Cl/6YwJeMunYR3xyxzw8CJdZ0czGgzS4r3OVEAQKPVW05tGVYtFOiir
 CKKWRqyNKNYmxia3N/YzdxdFtpZ0WjmkEPa3ZU3R+5zGHLownZXPLf+zprnSstAdfZ6M
 L0R9b6aJ9adQsoSnm/dEz0z3GlS8Yyr1srDf9AUOZWT12wNyQQdwvr9ZGl6cRQNSTQJ7
 UUV2DqLVfCUULtT41l6GSSikBS4ImHw3bi2gPMV9bIyRmLT1tlVnNPRRpYUCcg8ia3D1
 QFxw5AqCrSPHPKJbMuS85VzjYpYYzx3R2nA2IPZqb8Xw67u/kf8fCnURJlGWuEwvsCxg Ow== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3c726bkn97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 16:49:43 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 8 Nov
 2021 16:49:42 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 8 Nov 2021 16:49:42 -0800
Received: from irv1user01.caveonetworks.com (unknown [10.104.116.179])
        by maili.marvell.com (Postfix) with ESMTP id 3F6673F7041;
        Mon,  8 Nov 2021 16:49:42 -0800 (PST)
Received: from localhost (aeasi@localhost)
        by irv1user01.caveonetworks.com (8.14.4/8.14.4/Submit) with ESMTP id 1A90nfdh011120;
        Mon, 8 Nov 2021 16:49:42 -0800
X-Authentication-Warning: irv1user01.caveonetworks.com: aeasi owned process doing -bs
Date:   Mon, 8 Nov 2021 16:49:41 -0800
From:   Arun Easi <aeasi@marvell.com>
X-X-Sender: aeasi@irv1user01.caveonetworks.com
To:     "Ewan D. Milne" <emilne@redhat.com>
CC:     <linux-scsi@vger.kernel.org>, <stable@vger.kernel.org>,
        <njavali@marvell.com>
Subject: Re: [EXT] [PATCH] scsi: qla2xxx: fix mailbox direction flags in
 qla2xxx_get_adapter_id()
In-Reply-To: <20211108183012.13895-1-emilne@redhat.com>
Message-ID: <alpine.LRH.2.21.9999.2111081648230.30062@irv1user01.caveonetworks.com>
References: <20211108183012.13895-1-emilne@redhat.com>
User-Agent: Alpine 2.21.9999 (LRH 334 2019-03-29)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Proofpoint-ORIG-GUID: 6sSZrXN6_SkSuRuTUwIJzIXtmtS6KTLn
X-Proofpoint-GUID: 6sSZrXN6_SkSuRuTUwIJzIXtmtS6KTLn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-08_07,2021-11-08_02,2020-04-07_01
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looks good. Thanks Ewan.

Reviewed-by: Arun Easi <aeasi@marvell.com>

Regards,
-Arun

On Mon, 8 Nov 2021, 10:30am, Ewan D. Milne wrote:

>
> The SCM changes set the flags in mcp->out_mb instead of mcp->in_mb
> so the data was not actually being read into the mcp->mb[] array from
> the adapter.
> 
> Fixes: 9f2475fe7406 ("scsi: qla2xxx: SAN congestion management implementation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> ---
>  drivers/scsi/qla2xxx/qla_mbx.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
> index 7811c4952035..a6debeea3079 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -1695,10 +1695,8 @@ qla2x00_get_adapter_id(scsi_qla_host_t *vha, uint16_t *id, uint8_t *al_pa,
>  		mcp->in_mb |= MBX_13|MBX_12|MBX_11|MBX_10;
>  	if (IS_FWI2_CAPABLE(vha->hw))
>  		mcp->in_mb |= MBX_19|MBX_18|MBX_17|MBX_16;
> -	if (IS_QLA27XX(vha->hw) || IS_QLA28XX(vha->hw)) {
> -		mcp->in_mb |= MBX_15;
> -		mcp->out_mb |= MBX_7|MBX_21|MBX_22|MBX_23;
> -	}
> +	if (IS_QLA27XX(vha->hw) || IS_QLA28XX(vha->hw))
> +		mcp->in_mb |= MBX_15|MBX_21|MBX_22|MBX_23;
>  
>  	mcp->tov = MBX_TOV_SECONDS;
>  	mcp->flags = 0;
> 

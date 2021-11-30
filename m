Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2157462BC0
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 05:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232893AbhK3ElK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 23:41:10 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:7742 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232820AbhK3ElK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 23:41:10 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AU42HMC028128;
        Tue, 30 Nov 2021 04:37:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=I4/8xP+P5naVpDMQKQw3wl7Q2Zf67qDaHP6sdRJzeQc=;
 b=RRxEmRuyDHfcYOoU7HzmAD41H9l+ng8IkithTiMfYI8TQW5GRRF04XX3yEBc+Gz1oRGe
 wds0OQG7n+jMIh7BBRgIheO7v0KBFy028pOxeqQEEXgd5sRy+elrkqYc8Yrly9yLw1XM
 mz1b+Ika/IKdP9Z/DpiJoAdE/KiEQ47IL5rZMzfM1JA5Yn6kI79S/N1QtvDLVY1XSFBV
 0vQJE02pJx3GVlz7Q2OGJHWx2tSbephTUjGEUniDiV3PCHVrQPnn7m3UXzSk2PUKz3It
 wq7ycbj/xuTUbTUtR0DH5wGPtyCo4B2gSiUfrodpbwoIJlIfOAPhaa+icrFv78KBjDVe /g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cmu1we5vc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Nov 2021 04:37:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AU4ZbA9145685;
        Tue, 30 Nov 2021 04:37:49 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3ckaqe0p2r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Nov 2021 04:37:48 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1AU4blLc152494;
        Tue, 30 Nov 2021 04:37:48 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3030.oracle.com with ESMTP id 3ckaqe0p2c-2;
        Tue, 30 Nov 2021 04:37:48 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, James Smart <jsmart2021@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Paul Ely <paul.ely@broadcom.com>, stable@vger.kernel.org
Subject: Re: [PATCH] lpfc: Fix nonrecovery of remote ports following an unsolicited LOGO
Date:   Mon, 29 Nov 2021 23:37:46 -0500
Message-Id: <163824680188.31422.4555155751798537025.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211123165646.62740-1-jsmart2021@gmail.com>
References: <20211123165646.62740-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: _MFllKRhPEUkF9m3StPTWLm4nh6mf_zk
X-Proofpoint-ORIG-GUID: _MFllKRhPEUkF9m3StPTWLm4nh6mf_zk
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 23 Nov 2021 08:56:46 -0800, James Smart wrote:

> A commit introduced formal regstration of all Fabric nodes to the SCSI
> transport as well as REG/UNREG RPI mailbox requests. The commit
> introduced the NLP_RELEASE_RPI flag for rports  set in the
> lpfc_cmpl_els_logo_acc() routine to help clean up the RPIs. This new
> code caused the driver to release the RPI value used for the remote port
> and marked the RPI invalid.  When the driver later attempted to re-login,
> it would use the invalid RPI and the adapter rejected the PLOGI request.
> As no login occurred, the devloss timer on the rport expired and
> connectivity was lost.
> 
> [...]

Applied to 5.16/scsi-fixes, thanks!

[1/1] lpfc: Fix nonrecovery of remote ports following an unsolicited LOGO
      https://git.kernel.org/mkp/scsi/c/0956ba63bd94

-- 
Martin K. Petersen	Oracle Linux Engineering

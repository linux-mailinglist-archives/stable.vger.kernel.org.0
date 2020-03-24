Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2427B190FD8
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728852AbgCXNXi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:23:38 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40656 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729138AbgCXNXi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Mar 2020 09:23:38 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02ODNZi6011310;
        Tue, 24 Mar 2020 13:23:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=becv5FYJXzs3JnZ2rYy3TkDqfdaAi9xKRTFsZMsQFiY=;
 b=jWhoLaCSPQBNO5yNvn9VlMsIFN4OCFBwosat3YcVAyrzDlvhgHs5h3LTm0UCpB/zgexl
 1j/LZkM7akjYVFW9qpAoG0fR79rCAZE9lgMZ/Rm121GJd8FFpJkaQA4iuf4JIBR9YBoi
 Jv9TAu7lmXQLQBc+hwJn/ZYdzxVYjiuhcw0535MwRNFgg0UQrdryDbq0WjDNsdTi2jtm
 FLkFFHxQsNttOlveftwmA9kEKy5GkCiQ18BHFZEIFCw8Zdviv0nBIQh4nsstv6WZsVjC
 lIpwEv8bNtSXlPw+Ckv6lRh+w3fbLJUXiErPEfI0S5jhYCLGQkUkyIB32/XxZZWMUthf PA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2ywavm47ua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 13:23:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02ODNYlH115932;
        Tue, 24 Mar 2020 13:23:34 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2yxw6mpyds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 13:23:34 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02ODNQSF031276;
        Tue, 24 Mar 2020 13:23:26 GMT
Received: from localhost.localdomain (/114.88.246.185)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Mar 2020 06:23:25 -0700
From:   Bob Liu <bob.liu@oracle.com>
To:     dm-devel@redhat.com
Cc:     Damien.LeMoal@wdc.com, linux-block@vger.kernel.org,
        Dmitry.Fomichev@wdc.com, snitzer@redhat.com,
        Bob Liu <bob.liu@oracle.com>, stable@vger.kernel.org
Subject: [PATCH resend] dm zoned: remove duplicated nr_rnd_zones increasement
Date:   Tue, 24 Mar 2020 21:22:45 +0800
Message-Id: <20200324132245.27843-1-bob.liu@oracle.com>
X-Mailer: git-send-email 2.9.5
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9569 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003240072
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9569 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 clxscore=1011 impostorscore=0
 phishscore=0 suspectscore=1 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003240072
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

zmd->nr_rnd_zones was increased twice by mistake.
The other place:
1131                 zmd->nr_useable_zones++;
1132                 if (dmz_is_rnd(zone)) {
1133                         zmd->nr_rnd_zones++;
					^^^

Cc: stable@vger.kernel.org
Fixes: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device target")
Signed-off-by: Bob Liu <bob.liu@oracle.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/md/dm-zoned-metadata.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index 516c7b6..369de15 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -1109,7 +1109,6 @@ static int dmz_init_zone(struct blk_zone *blkz, unsigned int idx, void *data)
 	switch (blkz->type) {
 	case BLK_ZONE_TYPE_CONVENTIONAL:
 		set_bit(DMZ_RND, &zone->flags);
-		zmd->nr_rnd_zones++;
 		break;
 	case BLK_ZONE_TYPE_SEQWRITE_REQ:
 	case BLK_ZONE_TYPE_SEQWRITE_PREF:
-- 
2.9.5


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62D8C68FDF
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389337AbfGOORX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:17:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34192 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388990AbfGOORW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:17:22 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BAF193092647;
        Mon, 15 Jul 2019 14:17:21 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-65.pek2.redhat.com [10.72.12.65])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1CAAF60DDF;
        Mon, 15 Jul 2019 14:17:16 +0000 (UTC)
Subject: Re: [PATCH for-rc] RDMA/bnxt_re: Honor vlan_id in GID entry
 comparison
To:     Selvin Xavier <selvin.xavier@broadcom.com>,
        linux-rdma@vger.kernel.org, dledford@redhat.com, jgg@ziepe.ca
Cc:     stable@vger.kernel.org, linux-nvme@lists.infradead.org,
        Parav Pandit <parav@mellanox.com>
References: <20190715091913.15726-1-selvin.xavier@broadcom.com>
From:   Yi Zhang <yi.zhang@redhat.com>
Message-ID: <bdac6832-ba92-2609-a678-982413a87307@redhat.com>
Date:   Mon, 15 Jul 2019 22:17:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190715091913.15726-1-selvin.xavier@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Mon, 15 Jul 2019 14:17:21 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Verified this patch on my nvme rdma bnxt_re environment, thanks.

Tested-by: Yi Zhang <yi.zhang@redhat.com>

On 7/15/19 5:19 PM, Selvin Xavier wrote:
> GID entry consist of GID, vlan, netdev and smac.
> Extend GID duplicate check companions to consider vlan_id as well
> to support IPv6 VLAN based link local addresses. Introduce
> a new structure (bnxt_qplib_gid_info) to hold gid and vlan_id information.
>
> The issue is discussed in the following thread
> https://www.spinics.net/lists/linux-rdma/msg81594.html
>
> Fixes: 823b23da7113 ("IB/core: Allow vlan link local address based RoCE GIDs")
> Cc: <stable@vger.kernel.org> # v5.2+
> Reported-by: Yi Zhang <yi.zhang@redhat.com>
> Co-developed-by: Parav Pandit <parav@mellanox.com>
> Signed-off-by: Parav Pandit <parav@mellanox.com>
> Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
> ---
>   drivers/infiniband/hw/bnxt_re/ib_verbs.c  |  7 +++++--
>   drivers/infiniband/hw/bnxt_re/qplib_res.c | 13 +++++++++----
>   drivers/infiniband/hw/bnxt_re/qplib_res.h |  2 +-
>   drivers/infiniband/hw/bnxt_re/qplib_sp.c  | 14 +++++++++-----
>   drivers/infiniband/hw/bnxt_re/qplib_sp.h  |  7 ++++++-
>   5 files changed, 30 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> index 2c3685faa57a..a4a9f90f2482 100644
> --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> @@ -308,6 +308,7 @@ int bnxt_re_del_gid(const struct ib_gid_attr *attr, void **context)
>   	struct bnxt_re_dev *rdev = to_bnxt_re_dev(attr->device, ibdev);
>   	struct bnxt_qplib_sgid_tbl *sgid_tbl = &rdev->qplib_res.sgid_tbl;
>   	struct bnxt_qplib_gid *gid_to_del;
> +	u16 vlan_id = 0xFFFF;
>   
>   	/* Delete the entry from the hardware */
>   	ctx = *context;
> @@ -317,7 +318,8 @@ int bnxt_re_del_gid(const struct ib_gid_attr *attr, void **context)
>   	if (sgid_tbl && sgid_tbl->active) {
>   		if (ctx->idx >= sgid_tbl->max)
>   			return -EINVAL;
> -		gid_to_del = &sgid_tbl->tbl[ctx->idx];
> +		gid_to_del = &sgid_tbl->tbl[ctx->idx].gid;
> +		vlan_id = sgid_tbl->tbl[ctx->idx].vlan_id;
>   		/* DEL_GID is called in WQ context(netdevice_event_work_handler)
>   		 * or via the ib_unregister_device path. In the former case QP1
>   		 * may not be destroyed yet, in which case just return as FW
> @@ -335,7 +337,8 @@ int bnxt_re_del_gid(const struct ib_gid_attr *attr, void **context)
>   		}
>   		ctx->refcnt--;
>   		if (!ctx->refcnt) {
> -			rc = bnxt_qplib_del_sgid(sgid_tbl, gid_to_del, true);
> +			rc = bnxt_qplib_del_sgid(sgid_tbl, gid_to_del,
> +						 vlan_id,  true);
>   			if (rc) {
>   				dev_err(rdev_to_dev(rdev),
>   					"Failed to remove GID: %#x", rc);
> diff --git a/drivers/infiniband/hw/bnxt_re/qplib_res.c b/drivers/infiniband/hw/bnxt_re/qplib_res.c
> index 37928b1111df..bdbde8e22420 100644
> --- a/drivers/infiniband/hw/bnxt_re/qplib_res.c
> +++ b/drivers/infiniband/hw/bnxt_re/qplib_res.c
> @@ -488,7 +488,7 @@ static int bnxt_qplib_alloc_sgid_tbl(struct bnxt_qplib_res *res,
>   				     struct bnxt_qplib_sgid_tbl *sgid_tbl,
>   				     u16 max)
>   {
> -	sgid_tbl->tbl = kcalloc(max, sizeof(struct bnxt_qplib_gid), GFP_KERNEL);
> +	sgid_tbl->tbl = kcalloc(max, sizeof(*sgid_tbl->tbl), GFP_KERNEL);
>   	if (!sgid_tbl->tbl)
>   		return -ENOMEM;
>   
> @@ -526,9 +526,10 @@ static void bnxt_qplib_cleanup_sgid_tbl(struct bnxt_qplib_res *res,
>   	for (i = 0; i < sgid_tbl->max; i++) {
>   		if (memcmp(&sgid_tbl->tbl[i], &bnxt_qplib_gid_zero,
>   			   sizeof(bnxt_qplib_gid_zero)))
> -			bnxt_qplib_del_sgid(sgid_tbl, &sgid_tbl->tbl[i], true);
> +			bnxt_qplib_del_sgid(sgid_tbl, &sgid_tbl->tbl[i].gid,
> +					    sgid_tbl->tbl[i].vlan_id, true);
>   	}
> -	memset(sgid_tbl->tbl, 0, sizeof(struct bnxt_qplib_gid) * sgid_tbl->max);
> +	memset(sgid_tbl->tbl, 0, sizeof(*sgid_tbl->tbl) * sgid_tbl->max);
>   	memset(sgid_tbl->hw_id, -1, sizeof(u16) * sgid_tbl->max);
>   	memset(sgid_tbl->vlan, 0, sizeof(u8) * sgid_tbl->max);
>   	sgid_tbl->active = 0;
> @@ -537,7 +538,11 @@ static void bnxt_qplib_cleanup_sgid_tbl(struct bnxt_qplib_res *res,
>   static void bnxt_qplib_init_sgid_tbl(struct bnxt_qplib_sgid_tbl *sgid_tbl,
>   				     struct net_device *netdev)
>   {
> -	memset(sgid_tbl->tbl, 0, sizeof(struct bnxt_qplib_gid) * sgid_tbl->max);
> +	u32 i;
> +
> +	for (i = 0; i < sgid_tbl->max; i++)
> +		sgid_tbl->tbl[i].vlan_id = 0xffff;
> +
>   	memset(sgid_tbl->hw_id, -1, sizeof(u16) * sgid_tbl->max);
>   }
>   
> diff --git a/drivers/infiniband/hw/bnxt_re/qplib_res.h b/drivers/infiniband/hw/bnxt_re/qplib_res.h
> index 30c42c92fac7..fbda11a7ab1a 100644
> --- a/drivers/infiniband/hw/bnxt_re/qplib_res.h
> +++ b/drivers/infiniband/hw/bnxt_re/qplib_res.h
> @@ -111,7 +111,7 @@ struct bnxt_qplib_pd_tbl {
>   };
>   
>   struct bnxt_qplib_sgid_tbl {
> -	struct bnxt_qplib_gid		*tbl;
> +	struct bnxt_qplib_gid_info	*tbl;
>   	u16				*hw_id;
>   	u16				max;
>   	u16				active;
> diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.c b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
> index 48793d3512ac..40296b97d21e 100644
> --- a/drivers/infiniband/hw/bnxt_re/qplib_sp.c
> +++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
> @@ -213,12 +213,12 @@ int bnxt_qplib_get_sgid(struct bnxt_qplib_res *res,
>   			index, sgid_tbl->max);
>   		return -EINVAL;
>   	}
> -	memcpy(gid, &sgid_tbl->tbl[index], sizeof(*gid));
> +	memcpy(gid, &sgid_tbl->tbl[index].gid, sizeof(*gid));
>   	return 0;
>   }
>   
>   int bnxt_qplib_del_sgid(struct bnxt_qplib_sgid_tbl *sgid_tbl,
> -			struct bnxt_qplib_gid *gid, bool update)
> +			struct bnxt_qplib_gid *gid, u16 vlan_id, bool update)
>   {
>   	struct bnxt_qplib_res *res = to_bnxt_qplib(sgid_tbl,
>   						   struct bnxt_qplib_res,
> @@ -236,7 +236,8 @@ int bnxt_qplib_del_sgid(struct bnxt_qplib_sgid_tbl *sgid_tbl,
>   		return -ENOMEM;
>   	}
>   	for (index = 0; index < sgid_tbl->max; index++) {
> -		if (!memcmp(&sgid_tbl->tbl[index], gid, sizeof(*gid)))
> +		if (!memcmp(&sgid_tbl->tbl[index].gid, gid, sizeof(*gid)) &&
> +		    vlan_id == sgid_tbl->tbl[index].vlan_id)
>   			break;
>   	}
>   	if (index == sgid_tbl->max) {
> @@ -262,8 +263,9 @@ int bnxt_qplib_del_sgid(struct bnxt_qplib_sgid_tbl *sgid_tbl,
>   		if (rc)
>   			return rc;
>   	}
> -	memcpy(&sgid_tbl->tbl[index], &bnxt_qplib_gid_zero,
> +	memcpy(&sgid_tbl->tbl[index].gid, &bnxt_qplib_gid_zero,
>   	       sizeof(bnxt_qplib_gid_zero));
> +	sgid_tbl->tbl[index].vlan_id = 0xFFFF;
>   	sgid_tbl->vlan[index] = 0;
>   	sgid_tbl->active--;
>   	dev_dbg(&res->pdev->dev,
> @@ -296,7 +298,8 @@ int bnxt_qplib_add_sgid(struct bnxt_qplib_sgid_tbl *sgid_tbl,
>   	}
>   	free_idx = sgid_tbl->max;
>   	for (i = 0; i < sgid_tbl->max; i++) {
> -		if (!memcmp(&sgid_tbl->tbl[i], gid, sizeof(*gid))) {
> +		if (!memcmp(&sgid_tbl->tbl[i], gid, sizeof(*gid)) &&
> +		    sgid_tbl->tbl[i].vlan_id == vlan_id) {
>   			dev_dbg(&res->pdev->dev,
>   				"SGID entry already exist in entry %d!\n", i);
>   			*index = i;
> @@ -351,6 +354,7 @@ int bnxt_qplib_add_sgid(struct bnxt_qplib_sgid_tbl *sgid_tbl,
>   	}
>   	/* Add GID to the sgid_tbl */
>   	memcpy(&sgid_tbl->tbl[free_idx], gid, sizeof(*gid));
> +	sgid_tbl->tbl[free_idx].vlan_id = vlan_id;
>   	sgid_tbl->active++;
>   	if (vlan_id != 0xFFFF)
>   		sgid_tbl->vlan[free_idx] = 1;
> diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.h b/drivers/infiniband/hw/bnxt_re/qplib_sp.h
> index 0ec3b12b0bcd..13d9432d5ce2 100644
> --- a/drivers/infiniband/hw/bnxt_re/qplib_sp.h
> +++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.h
> @@ -84,6 +84,11 @@ struct bnxt_qplib_gid {
>   	u8				data[16];
>   };
>   
> +struct bnxt_qplib_gid_info {
> +	struct bnxt_qplib_gid gid;
> +	u16 vlan_id;
> +};
> +
>   struct bnxt_qplib_ah {
>   	struct bnxt_qplib_gid		dgid;
>   	struct bnxt_qplib_pd		*pd;
> @@ -221,7 +226,7 @@ int bnxt_qplib_get_sgid(struct bnxt_qplib_res *res,
>   			struct bnxt_qplib_sgid_tbl *sgid_tbl, int index,
>   			struct bnxt_qplib_gid *gid);
>   int bnxt_qplib_del_sgid(struct bnxt_qplib_sgid_tbl *sgid_tbl,
> -			struct bnxt_qplib_gid *gid, bool update);
> +			struct bnxt_qplib_gid *gid, u16 vlan_id, bool update);
>   int bnxt_qplib_add_sgid(struct bnxt_qplib_sgid_tbl *sgid_tbl,
>   			struct bnxt_qplib_gid *gid, u8 *mac, u16 vlan_id,
>   			bool update, u32 *index);

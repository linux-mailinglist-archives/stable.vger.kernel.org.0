Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B12A36E4DC1
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 17:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbjDQP4F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 11:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231499AbjDQP4C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 11:56:02 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF52440CD;
        Mon, 17 Apr 2023 08:55:55 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 410CA219FB;
        Mon, 17 Apr 2023 15:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1681746954; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wEk0ZNBjt4S2t/wbsSwJCfF0qX8aYfy5nXrFzhWIpEE=;
        b=B3cqQUlgz8d9wS5ZBek2c0pfM6h/ZcISWX+Hvi+2rJgw9joIF1GEy5FiztOXD6mDCegymu
        keWeZDoh8Ee6HUaDMxrXXA2o85YKTAJORYPeO9skx9gKwl3cuR1RFUveTN533tR9rJgqS7
        7PDJ7EOuP4tX1U6GRlrO6hO7gAMGIqU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1681746954;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wEk0ZNBjt4S2t/wbsSwJCfF0qX8aYfy5nXrFzhWIpEE=;
        b=dEd/TwjyMWbB2dq4r+HpjA7rIZvVel5l5ouQ6uLdOHNLJqsJ76bXecL4j+RZ/QyXvdTYJG
        UCk8hXiWZAOAgpBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C428713319;
        Mon, 17 Apr 2023 15:55:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id NWm/LAlsPWQ7RAAAMHmgww
        (envelope-from <lhenriques@suse.de>); Mon, 17 Apr 2023 15:55:53 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 7bdb5741;
        Mon, 17 Apr 2023 15:55:53 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, mchangir@redhat.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] ceph: fix potential use-after-free bug when trimming
 caps
References: <20230417120850.60880-1-xiubli@redhat.com>
Date:   Mon, 17 Apr 2023 16:55:52 +0100
In-Reply-To: <20230417120850.60880-1-xiubli@redhat.com> (xiubli@redhat.com's
        message of "Mon, 17 Apr 2023 20:08:50 +0800")
Message-ID: <87354yec53.fsf@brahms.olymp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

xiubli@redhat.com writes:

> From: Xiubo Li <xiubli@redhat.com>
>
> When trimming the caps and just after the 'session->s_cap_lock' is
> released in ceph_iterate_session_caps() the cap maybe removed by
> another thread, and when using the stale cap memory in the callbacks
> it will trigger use-after-free crash.
>
> We need to check the existence of the cap just after the 'ci->i_ceph_lock'
> being acquired. And do nothing if it's already removed.
>
> Cc: stable@vger.kernel.org
> URL: https://bugzilla.redhat.com/show_bug.cgi?id=3D2186264

I didn't had time to look closer at what this patch is fixing but the
above URL requires a account to access it.  So I guess it should be
dropped or replaced by another one from the tracker...?

Also, just skimming through the patch, there are at least 2 obvious issues
with it.  See below.

> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>
> V2:
> - Fix this in ceph_iterate_session_caps instead.
>
>
>  fs/ceph/debugfs.c    |  7 +++++-
>  fs/ceph/mds_client.c | 56 ++++++++++++++++++++++++++++++--------------
>  fs/ceph/mds_client.h |  2 +-
>  3 files changed, 46 insertions(+), 19 deletions(-)
>
> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> index bec3c4549c07..5c0f07df5b02 100644
> --- a/fs/ceph/debugfs.c
> +++ b/fs/ceph/debugfs.c
> @@ -248,14 +248,19 @@ static int metrics_caps_show(struct seq_file *s, vo=
id *p)
>  	return 0;
>  }
>=20=20
> -static int caps_show_cb(struct inode *inode, struct ceph_cap *cap, void =
*p)
> +static int caps_show_cb(struct inode *inode, struct rb_node *ci_node, vo=
id *p)
>  {
> +	struct ceph_inode_info *ci =3D ceph_inode(inode);
>  	struct seq_file *s =3D p;
> +	struct ceph_cap *cap;
>=20=20
> +	spin_lock(&ci->i_ceph_lock);
> +	cap =3D rb_entry(ci_node, struct ceph_cap, ci_node);
>  	seq_printf(s, "0x%-17llx%-3d%-17s%-17s\n", ceph_ino(inode),
>  		   cap->session->s_mds,
>  		   ceph_cap_string(cap->issued),
>  		   ceph_cap_string(cap->implemented));
> +	spin_unlock(&ci->i_ceph_lock);
>  	return 0;
>  }
>=20=20
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 294af79c25c9..7fcfbddd534d 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -1786,7 +1786,7 @@ static void cleanup_session_requests(struct ceph_md=
s_client *mdsc,
>   * Caller must hold session s_mutex.
>   */
>  int ceph_iterate_session_caps(struct ceph_mds_session *session,
> -			      int (*cb)(struct inode *, struct ceph_cap *,
> +			      int (*cb)(struct inode *, struct rb_node *ci_node,
>  					void *), void *arg)
>  {
>  	struct list_head *p;
> @@ -1799,6 +1799,8 @@ int ceph_iterate_session_caps(struct ceph_mds_sessi=
on *session,
>  	spin_lock(&session->s_cap_lock);
>  	p =3D session->s_caps.next;
>  	while (p !=3D &session->s_caps) {
> +		struct rb_node *ci_node;
> +
>  		cap =3D list_entry(p, struct ceph_cap, session_caps);
>  		inode =3D igrab(&cap->ci->netfs.inode);
>  		if (!inode) {
> @@ -1806,6 +1808,7 @@ int ceph_iterate_session_caps(struct ceph_mds_sessi=
on *session,
>  			continue;
>  		}
>  		session->s_cap_iterator =3D cap;
> +		ci_node =3D &cap->ci_node;
>  		spin_unlock(&session->s_cap_lock);
>=20=20
>  		if (last_inode) {
> @@ -1817,7 +1820,7 @@ int ceph_iterate_session_caps(struct ceph_mds_sessi=
on *session,
>  			old_cap =3D NULL;
>  		}
>=20=20
> -		ret =3D cb(inode, cap, arg);
> +		ret =3D cb(inode, ci_node, arg);
>  		last_inode =3D inode;
>=20=20
>  		spin_lock(&session->s_cap_lock);
> @@ -1850,17 +1853,22 @@ int ceph_iterate_session_caps(struct ceph_mds_ses=
sion *session,
>  	return ret;
>  }
>=20=20
> -static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *=
cap,
> +static int remove_session_caps_cb(struct inode *inode, struct rb_node *c=
i_node,
>  				  void *arg)
>  {
>  	struct ceph_inode_info *ci =3D ceph_inode(inode);
>  	bool invalidate =3D false;
> +	struct ceph_cap *cap;
>  	int iputs;
>=20=20
> -	dout("removing cap %p, ci is %p, inode is %p\n",
> -	     cap, ci, &ci->netfs.inode);
>  	spin_lock(&ci->i_ceph_lock);
> -	iputs =3D ceph_purge_inode_cap(inode, cap, &invalidate);

This will leave iputs uninitialized if the statement below returns NULL.
Which will cause issues later in the function.

> +	cap =3D rb_entry(ci_node, struct ceph_cap, ci_node);
> +	if (cap) {
> +		dout(" removing cap %p, ci is %p, inode is %p\n",
> +		     cap, ci, &ci->netfs.inode);
> +
> +		iputs =3D ceph_purge_inode_cap(inode, cap, &invalidate);
> +	}
>  	spin_unlock(&ci->i_ceph_lock);
>=20=20
>  	wake_up_all(&ci->i_cap_wq);
> @@ -1934,11 +1942,11 @@ enum {
>   *
>   * caller must hold s_mutex.
>   */
> -static int wake_up_session_cb(struct inode *inode, struct ceph_cap *cap,
> -			      void *arg)
> +static int wake_up_session_cb(struct inode *inode, struct rb_node *ci_no=
de, void *arg)
>  {
>  	struct ceph_inode_info *ci =3D ceph_inode(inode);
>  	unsigned long ev =3D (unsigned long)arg;
> +	struct ceph_cap *cap;
>=20=20
>  	if (ev =3D=3D RECONNECT) {
>  		spin_lock(&ci->i_ceph_lock);
> @@ -1949,7 +1957,9 @@ static int wake_up_session_cb(struct inode *inode, =
struct ceph_cap *cap,
>  		if (cap->cap_gen < atomic_read(&cap->session->s_cap_gen)) {

Since we're replacing the 'cap' argument by the 'ci_node', the
above statement will have garbage in 'cap'.

Cheers,
--=20
Lu=C3=ADs

>  			/* mds did not re-issue stale cap */
>  			spin_lock(&ci->i_ceph_lock);
> -			cap->issued =3D cap->implemented =3D CEPH_CAP_PIN;
> +			cap =3D rb_entry(ci_node, struct ceph_cap, ci_node);
> +			if (cap)
> +				cap->issued =3D cap->implemented =3D CEPH_CAP_PIN;
>  			spin_unlock(&ci->i_ceph_lock);
>  		}
>  	} else if (ev =3D=3D FORCE_RO) {
> @@ -2113,16 +2123,22 @@ static bool drop_negative_children(struct dentry =
*dentry)
>   * Yes, this is a bit sloppy.  Our only real goal here is to respond to
>   * memory pressure from the MDS, though, so it needn't be perfect.
>   */
> -static int trim_caps_cb(struct inode *inode, struct ceph_cap *cap, void =
*arg)
> +static int trim_caps_cb(struct inode *inode, struct rb_node *ci_node, vo=
id *arg)
>  {
>  	int *remaining =3D arg;
>  	struct ceph_inode_info *ci =3D ceph_inode(inode);
>  	int used, wanted, oissued, mine;
> +	struct ceph_cap *cap;
>=20=20
>  	if (*remaining <=3D 0)
>  		return -1;
>=20=20
>  	spin_lock(&ci->i_ceph_lock);
> +	cap =3D rb_entry(ci_node, struct ceph_cap, ci_node);
> +	if (!cap) {
> +		spin_unlock(&ci->i_ceph_lock);
> +		return 0;
> +	}
>  	mine =3D cap->issued | cap->implemented;
>  	used =3D __ceph_caps_used(ci);
>  	wanted =3D __ceph_caps_file_wanted(ci);
> @@ -4265,26 +4281,23 @@ static struct dentry* d_find_primary(struct inode=
 *inode)
>  /*
>   * Encode information about a cap for a reconnect with the MDS.
>   */
> -static int reconnect_caps_cb(struct inode *inode, struct ceph_cap *cap,
> +static int reconnect_caps_cb(struct inode *inode, struct rb_node *ci_nod=
e,
>  			  void *arg)
>  {
>  	union {
>  		struct ceph_mds_cap_reconnect v2;
>  		struct ceph_mds_cap_reconnect_v1 v1;
>  	} rec;
> -	struct ceph_inode_info *ci =3D cap->ci;
> +	struct ceph_inode_info *ci =3D ceph_inode(inode);
>  	struct ceph_reconnect_state *recon_state =3D arg;
>  	struct ceph_pagelist *pagelist =3D recon_state->pagelist;
>  	struct dentry *dentry;
> +	struct ceph_cap *cap;
>  	char *path;
> -	int pathlen =3D 0, err;
> +	int pathlen =3D 0, err =3D 0;
>  	u64 pathbase;
>  	u64 snap_follows;
>=20=20
> -	dout(" adding %p ino %llx.%llx cap %p %lld %s\n",
> -	     inode, ceph_vinop(inode), cap, cap->cap_id,
> -	     ceph_cap_string(cap->issued));
> -
>  	dentry =3D d_find_primary(inode);
>  	if (dentry) {
>  		/* set pathbase to parent dir when msg_version >=3D 2 */
> @@ -4301,6 +4314,15 @@ static int reconnect_caps_cb(struct inode *inode, =
struct ceph_cap *cap,
>  	}
>=20=20
>  	spin_lock(&ci->i_ceph_lock);
> +	cap =3D rb_entry(ci_node, struct ceph_cap, ci_node);
> +	if (!cap) {
> +		spin_lock(&ci->i_ceph_lock);
> +		goto out_err;
> +	}
> +	dout(" adding %p ino %llx.%llx cap %p %lld %s\n",
> +	     inode, ceph_vinop(inode), cap, cap->cap_id,
> +	     ceph_cap_string(cap->issued));
> +
>  	cap->seq =3D 0;        /* reset cap seq */
>  	cap->issue_seq =3D 0;  /* and issue_seq */
>  	cap->mseq =3D 0;       /* and migrate_seq */
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 0f70ca3cdb21..001b69d04307 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -569,7 +569,7 @@ extern void ceph_queue_cap_reclaim_work(struct ceph_m=
ds_client *mdsc);
>  extern void ceph_reclaim_caps_nr(struct ceph_mds_client *mdsc, int nr);
>  extern int ceph_iterate_session_caps(struct ceph_mds_session *session,
>  				     int (*cb)(struct inode *,
> -					       struct ceph_cap *, void *),
> +					       struct rb_node *ci_node, void *),
>  				     void *arg);
>  extern void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc);
>=20=20
> --=20
>
> 2.39.2
>

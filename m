Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03C3E549795
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbiFMQOK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 12:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241900AbiFMQM7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 12:12:59 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC47B23BFC
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 07:04:42 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id p129so7860029oig.3
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 07:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=d4vv+Xhgw7ovz5Ko1E1nfmzOmAIVX7jx+HhpbtzcVRw=;
        b=Yhd0mFywT8IC5E0HA4bWUrvqQYo81rBby5gVGwsfAhjolhj9Mf0DLvkKndbifiun5h
         7WRnVtm0PF8NqnNfCZjkLMCYyIHANFiIUg0vWphvmS91bmz7xqmk9Cj04nWL9/vxPLcT
         7EoiawQz1N0aHS740ZrUdgnmb7zFuIXzSS7kw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=d4vv+Xhgw7ovz5Ko1E1nfmzOmAIVX7jx+HhpbtzcVRw=;
        b=ODeMyrZJ9Y787ST0Z0xVh4fr67lF2IOTsVdGlG7+NwiBR+kKoO3SDBpDet42CIFJEP
         jqB8B3zKnh4yL+NwEEHhbnI7p/wr8DpLvxCvy7b2NJQDw9ekChhiozWcA9HrZ9ujOkmQ
         7W15aIjBtiBKZiP6CNyR/UQuGxH9ADGvN9Fnt3wh+grZZEIfx7U/8dxUEIvXjIKuHN2h
         om+8OIU7TmpljZ7fMiLE20nb6m/2VjYANglo37GzPfN15BDKOsj1lpFoSIfZj77Z3X3d
         Jn364syjtq4pXO1+uT4mn/N04ILKejpq/ZweiwBKPswnMqZDiibys7xDmcMZcJ9yseeE
         JvjQ==
X-Gm-Message-State: AOAM533CA/QNrPQEMGdqH1d+x3mfxAkO+Si4rnp91tYJZlP8pbv2J1cv
        V0Gcpbz1WjxVKs1aLluNmZFkzjNZjp11Zg==
X-Google-Smtp-Source: ABdhPJzzYgPyX98dIcX6eQI9fXrIZhuLNqqucbaZdCC7gKYID+r+1ElsTaflwODbz02NPzm9/OboYA==
X-Received: by 2002:a05:6808:e8f:b0:32e:59dd:4297 with SMTP id k15-20020a0568080e8f00b0032e59dd4297mr7010608oil.110.1655129082130;
        Mon, 13 Jun 2022 07:04:42 -0700 (PDT)
Received: from localhost ([136.34.15.133])
        by smtp.gmail.com with ESMTPSA id ec24-20020a0568708c1800b000f346e6d786sm3927629oab.54.2022.06.13.07.04.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 07:04:41 -0700 (PDT)
Date:   Mon, 13 Jun 2022 09:04:40 -0500
From:   Seth Forshee <sforshee@digitalocean.com>
To:     Christian Brauner <brauner@kernel.org>
Cc:     linux-fsdevel@vger.kernel.org,
        Seth Forshee <seth.forshee@digitalocean.com>,
        Christoph Hellwig <hch@lst.de>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Al Viro <viro@zeniv.linux.org.uk>, stable@vger.kernel.org
Subject: Re: [PATCH] fs: account for group membership
Message-ID: <YqdD+HGNIYZIG40e@do-x1extreme>
References: <20220613111517.2186646-1-brauner@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220613111517.2186646-1-brauner@kernel.org>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 13, 2022 at 01:15:17PM +0200, Christian Brauner wrote:
> When calling setattr_prepare() to determine the validity of the
> attributes the ia_{g,u}id fields contain the value that will be written
> to inode->i_{g,u}id. This is exactly the same for idmapped and
> non-idmapped mounts and allows callers to pass in the values they want
> to see written to inode->i_{g,u}id.
> 
> When group ownership is changed a caller whose fsuid owns the inode can
> change the group of the inode to any group they are a member of. When
> searching through the caller's groups we need to use the gid mapped
> according to the idmapped mount otherwise we will fail to change
> ownership for unprivileged users.
> 
> Consider a caller running with fsuid and fsgid 1000 using an idmapped
> mount that maps id 65534 to 1000 and 65535 to 1001. Consequently, a file
> owned by 65534:65535 in the filesystem will be owned by 1000:1001 in the
> idmapped mount.
> 
> The caller now requests the gid of the file to be changed to 1000 going
> through the idmapped mount. In the vfs we will immediately map the
> requested gid to the value that will need to be written to inode->i_gid
> and place it in attr->ia_gid. Since this idmapped mount maps 65534 to
> 1000 we place 65534 in attr->ia_gid.
> 
> When we check whether the caller is allowed to change group ownership we
> first validate that their fsuid matches the inode's uid. The
> inode->i_uid is 65534 which is mapped to uid 1000 in the idmapped mount.
> Since the caller's fsuid is 1000 we pass the check.
> 
> We now check whether the caller is allowed to change inode->i_gid to the
> requested gid by calling in_group_p(). This will compare the passed in
> gid to the caller's fsgid and search the caller's additional groups.
> 
> Since we're dealing with an idmapped mount we need to pass in the gid
> mapped according to the idmapped mount. This is akin to checking whether
> a caller is privileged over the future group the inode is owned by. And
> that needs to take the idmapped mount into account. Note, all helpers
> are nops without idmapped mounts.
> 
> New regression test sent to xfstests.
> 
> Link: https://github.com/lxc/lxd/issues/10537
> Fixes: 2f221d6f7b88 ("attr: handle idmapped mounts")
> Cc: Seth Forshee <seth.forshee@digitalocean.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Aleksa Sarai <cyphar@cyphar.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: stable@vger.kernel.org # 5.15+
> CC: linux-fsdevel@vger.kernel.org
> Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>

Looks correct to me.

Reviewed-by: Seth Forshee <sforshee@digitalocean.com>

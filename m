Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF8C3551F89
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 16:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242855AbiFTO5J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 10:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243063AbiFTO4v (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 10:56:51 -0400
Received: from mail-vk1-xa36.google.com (mail-vk1-xa36.google.com [IPv6:2607:f8b0:4864:20::a36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21CE1403D8;
        Mon, 20 Jun 2022 07:16:29 -0700 (PDT)
Received: by mail-vk1-xa36.google.com with SMTP id s141so2009664vks.0;
        Mon, 20 Jun 2022 07:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5kEYkCpnxoA3S01Zg95RU2E/SaxBzMektre65Ofjzb8=;
        b=SCHIQurypg4xLGaPenMIcv2Ru0SuMVRbeRhyu4V7nRUb/zWkdfIu79v2rTW73DnqGq
         DBunOWESbU/WDMuNrtfbc4xw9UkHfZNXxba27tNKEVmHnUYLqgGIO+CzXy2tZJdEV07F
         fJ8RTUCIvZlKEx8udICulqsTfoM+HabPFoqjROG1atu5kIDGDWrgVG6YyGsNcrIJozq+
         mmNzVkVRazregQTIQ2m4r7vK3c+I7VlS2YA+3QxzoqgD5I49KXXRQ39+Xj0FRWneepeH
         ALzxMdGI9gi3CBcSBU6MPlDOmw7DJAefQtH6lml57aE6qL4c6j2cjTJaCuWluoEMt0Uy
         mt5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5kEYkCpnxoA3S01Zg95RU2E/SaxBzMektre65Ofjzb8=;
        b=HGmJpVnmCpfN3W51nxC/HNNIGyja9ufQPlAFCNJkRf2aU/z/3HQfKY70wFn5NPBMEK
         3XersdIqurRs5vVGot62+DVaaoIJ7LgDrx+uF5l1VHdcD+dOv2EYZKVohjlCRoPC+wGF
         N5OYuvyQrypHajLmnNJrcGQbPFtaPKc6uVRHwAXINkNsRKH6IKD7YBQhfTkgsllIaioU
         KR7aTyJld2/Ez5ZJrgQzEl9B0eAdicAsi+Y0YU7b3TWM7UTw/IaMYXX4gXh802gOFb5d
         RFdFyGab1vI+ASwSoX8ShTmN7ecAVIvgv/UukMnC5Sb6XLWx94ZlYwz8KsVaRL0FvcUC
         +UUg==
X-Gm-Message-State: AJIora+iX33TtdLhEtmyDRHB2BObEOLJJTOagT6RwTyapVMHg+U5i+ja
        58HNV8GdtVlddj7xRJ9nhh1rTkKUsB124w9+yPY=
X-Google-Smtp-Source: AGRyM1v5NSQ8N7D3XCr8PYyaR3ZhJbspnMUPvBNeOQJn9nkLyDPORHi1sGCQqhHEIk4EkDpfPiIiq8OlA0gd7OlouSU=
X-Received: by 2002:a1f:c603:0:b0:36c:500c:d692 with SMTP id
 w3-20020a1fc603000000b0036c500cd692mr224571vkf.11.1655734587782; Mon, 20 Jun
 2022 07:16:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220511190213.831646-1-amir73il@gmail.com> <20220511190213.831646-3-amir73il@gmail.com>
In-Reply-To: <20220511190213.831646-3-amir73il@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 20 Jun 2022 17:16:16 +0300
Message-ID: <CAOQ4uxj6wdsoVf7pyJWhoJ9mcNWf0eU_ARsXf6rH_nwpG1DJDg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] fsnotify: consistent behavior for parent not
 watching children
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Matthew Bobrowski <mbobrowski@mbobrowski.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 11, 2022 at 10:02 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> The logic for handling events on child in groups that have a mark on
> the parent inode, but without FS_EVENT_ON_CHILD flag in the mask is
> duplicated in several places and inconsistent.
>
> Move the logic into the preparation of mark type iterator, so that the
> parent mark type will be excluded from all mark type iterations in that
> case.
>
> This results in several subtle changes of behavior, hopefully all
> desired changes of behavior, for example:
>
> - Group A has a mount mark with FS_MODIFY in mask
> - Group A has a mark with ignore mask that does not survive FS_MODIFY
>   and does not watch children on directory D.
> - Group B has a mark with FS_MODIFY in mask that does watch children
>   on directory D.
> - FS_MODIFY event on file D/foo should not clear the ignore mask of
>   group A, but before this change it does
>
> And if group A ignore mask was set to survive FS_MODIFY:
> - FS_MODIFY event on file D/foo should be reported to group A on account
>   of the mount mark, but before this change it is wrongly ignored
>
> Fixes: 2f02fd3fa13e ("fanotify: fix ignore mask logic for events on child and on dir")
> Reported-by: Jan Kara <jack@suse.com>
> Link: https://lore.kernel.org/linux-fsdevel/20220314113337.j7slrb5srxukztje@quack3.lan/
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---

Greg,

FYI, this needs the previous commit to apply to 5.18.y:

e730558adffb fsnotify: consistent behavior for parent not watching children
14362a254179 fsnotify: introduce mark type iterator

They won't apply to earlier versions and this is a fix for a very minor bug
that existed forever, so no need to bother.

Thanks,
Amir.

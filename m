Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2433529875
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 05:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234973AbiEQD5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 23:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236923AbiEQD5C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 23:57:02 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF40B33E36
        for <stable@vger.kernel.org>; Mon, 16 May 2022 20:56:56 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id e194so18033277iof.11
        for <stable@vger.kernel.org>; Mon, 16 May 2022 20:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1bXmoyQVi8HemPn4Ek3o70oT1bUxijWb4UFJy39qPh0=;
        b=L9p9SzUEpEdomLpzYE78DOiG9wS0nhuK8GDu1uWSALItE50krwKfSkLWycyhq8uxiB
         JbwJMuZtEjq0dsb3NXAXflxzEEcYtCuWabglv+bZWaniL6hkoI5h67vKRPQuEOuVrDLh
         r1zGfiWO+WgkXSxqfBxnFflHPY5UkdhVTfM15309K/2DB11VVS8HY8txh0csfKBqHY0Q
         2mow+nMVUieHRfTdP7xDKylFvZg0uR44LyrhZDWS79fd3UbhkED2zlbW9LV7DpHNT+Jj
         EgSH15PKG6wPCDxVOAho8NZsemlBBY2X/4la6ewme+we7GkbOjhPqUOouVEQDIXZ8oxr
         u5sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1bXmoyQVi8HemPn4Ek3o70oT1bUxijWb4UFJy39qPh0=;
        b=VN4+ktLHvIeLLnACgbOBiETAGHp2A7iA0gMF0mVKqUEa4lH5BaoOD6j+pV1AtQs2SE
         bkqTjGadywxIxg7om81kYr46L1qnzBF5QLg6WlhXIIT5/lFkBZDrj8iGQG9K8aaAcTpm
         wQvbZjwZ4hnfwAOC5b23Bn2IT7i22GT35L+QCb+T9v4AUw16wzVhrQYfpIGeGBYndptD
         W4hS3SgI1WsJIdtEMkx8MhyuEM9gR6cU9p94cieCzkwzptLkCJFhmPwiXnW1E1GFo5Tl
         r+4ATPk0OV6Wcg18EcrzQ+G/n6QfeQqE5DehU6U0CJT6R64rK+P60/AQEILEkuZPzmmA
         aFyw==
X-Gm-Message-State: AOAM533gfB7WjwpMCeH9iOC3yzyeb3z48pXbtbuIHNiztO1FjLuhIus+
        V52HnlcvR8zm9LbvFXEVsbdsyi9mPNStVULd9Ay5nzmJ4rE=
X-Google-Smtp-Source: ABdhPJy816tj5PjaqKLGO+mW7RLwXsI8smq6mLiVDEi2ceScQSnPkbdBIge9MlfnQaqu57ULnvb20x6+HVN6zUy3BEk=
X-Received: by 2002:a05:6602:2d8d:b0:649:f82b:c877 with SMTP id
 k13-20020a0566022d8d00b00649f82bc877mr9495775iow.66.1652759816272; Mon, 16
 May 2022 20:56:56 -0700 (PDT)
MIME-Version: 1.0
References: <Yn82ZO/Ysxq0v/0/@kroah.com> <20220514053453.3277330-1-meenashanmugam@google.com>
 <20220514053453.3277330-4-meenashanmugam@google.com> <YoLDak9O1c1gu54I@kroah.com>
In-Reply-To: <YoLDak9O1c1gu54I@kroah.com>
From:   Meena Shanmugam <meenashanmugam@google.com>
Date:   Mon, 16 May 2022 20:56:43 -0700
Message-ID: <CAMdnWFANgmoM_Mg5gZMxeBcNxKgMfSyEhuYCjpbM=DPZtUiaDg@mail.gmail.com>
Subject: Re: [PATCH 3/4] SUNRPC: Don't call connect() more than once on a TCP socket
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     enrico.scholz@sigma-chemnitz.de, stable@vger.kernel.org,
        trond.myklebust@hammerspace.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 16, 2022 at 2:34 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> This commit added a build warning.  Always properly test your changes,
> they can not add warnings.
>
> I've fixed it up by hand now.
>
> thanks,
>
> greg k-h

Sorry about that. Thank you for fixing it.

Thanks,
Meena

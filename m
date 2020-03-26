Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEE1E1942F0
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 16:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgCZPWB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 11:22:01 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:47116 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727717AbgCZPWA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Mar 2020 11:22:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585236119;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TTyRBiiPM/GehLX4R/d+xfAxJEtf+WIdgk9S++j+6Jk=;
        b=KhRenuvbq0ZmyS5Bj+R6O6ryxZcPw/ny3PNOsMLEsMo6fA+zH5OC5MmB8fEWyIFzgxNfXn
        KnMWdh0cJkNsi8xYsGXqzy95WwotEVyfIgWuoFQPqqWHALTwfq6CxxfqvaT57Iv/9W/8WS
        EFq8A2VDH+8USHTJtZ0TazGIk4t8TzU=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-CdbPcECfPYW259Uqjl2Ojg-1; Thu, 26 Mar 2020 11:21:57 -0400
X-MC-Unique: CdbPcECfPYW259Uqjl2Ojg-1
Received: by mail-lf1-f71.google.com with SMTP id q22so2376299lfj.23
        for <stable@vger.kernel.org>; Thu, 26 Mar 2020 08:21:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=TTyRBiiPM/GehLX4R/d+xfAxJEtf+WIdgk9S++j+6Jk=;
        b=uag35s7KRkGZ1cNvSxft9bg+DAiTBKVb4PEFhjArurc+PrNrTzGmoJnuvFLDxaiDzq
         Kc0qCL8L/NFwR2vkOIKtqpfepPYhP0RI4yVYmUlkSUURg6T8+i17hnqt8/aytbFR5495
         b0QAE4+DcQy27N3pNwtlURX58xRPDz/U677cO/ho9oS3omfgDtsLj0TiNl3Bi1lIhX35
         tveNR8EfzD2uCbXFVYZLC+R450JpnF1vrQuTn3UvAk8gV2SaI4U39jUbPQ9QwMrUADe7
         vwrpySQEIGNncZZ6JFpnJsKfeTANwm+FAqJtXlZM15SbPxNXHFbxN5bdVxDnQ88vssgl
         KqkA==
X-Gm-Message-State: ANhLgQ0Q4zBk3RPx5NZjLCMWbUVDx2ffYY1v2jPKowL02ad12CSDDNCA
        BDvZsDbOwfNA/3fdbB3eWOh4G5gfRtIjodh6vgNMKZNyu1thH7jwe4ksDOEG7GkddIWiNPJThtt
        rCJNHJsP9L+YLMs9f
X-Received: by 2002:ac2:5446:: with SMTP id d6mr6162889lfn.62.1585236115976;
        Thu, 26 Mar 2020 08:21:55 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtkKAcQI4kilGxRpxAJepaKReyo14QEMBIwFmujm9eQvF5/Ircy6SpEJYO5zJ5sITNx/Pob2g==
X-Received: by 2002:ac2:5446:: with SMTP id d6mr6162874lfn.62.1585236115677;
        Thu, 26 Mar 2020 08:21:55 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id o4sm1665987lfl.62.2020.03.26.08.21.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 08:21:54 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id DBF5218158B; Thu, 26 Mar 2020 16:21:53 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc:     Jouni Malinen <jouni@codeaurora.org>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mac80211: Check port authorization in the ieee80211_tx_dequeue() case
In-Reply-To: <20200326155133.ced84317ea29.I34d4c47cd8cc8a4042b38a76f16a601fbcbfd9b3@changeid>
References: <20200326155133.ced84317ea29.I34d4c47cd8cc8a4042b38a76f16a601fbcbfd9b3@changeid>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 26 Mar 2020 16:21:53 +0100
Message-ID: <875zernnu6.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> From: Jouni Malinen <jouni@codeaurora.org>
>
> mac80211 used to check port authorization in the Data frame enqueue case
> when going through start_xmit(). However, that authorization status may
> change while the frame is waiting in a queue. Add a similar check in the
> dequeue case to avoid sending previously accepted frames after
> authorization change. This provides additional protection against
> potential leaking of frames after a station has been disconnected and
> the keys for it are being removed.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Ah - nice find!

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>


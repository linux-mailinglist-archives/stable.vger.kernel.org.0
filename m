Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB2606ADA59
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 10:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbjCGJ3L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 04:29:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbjCGJ3K (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 04:29:10 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A04A2B619;
        Tue,  7 Mar 2023 01:29:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B049CCE1B1C;
        Tue,  7 Mar 2023 09:29:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93BF9C433D2;
        Tue,  7 Mar 2023 09:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678181341;
        bh=6r9u4cgsTdbwOk9qBsG4uVytDZaJlHqC6dEA0OjcLyA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YtfdUw9Cy5TFD4yjttQBEiIaBvXf3YaJvlyFzTTZphfbDXOyBnnyOyc9vXhaIru/x
         gi5WT0jCUf57NDHn1PFbcJ9smXdZ5ygxMQXXkvLkzcZa01SILr3BKGtN3Ukx2e0XX6
         RuL3H2+yAWVcX6pKt5fUUiVE6Ht//5ta45bZaeRA=
Date:   Tue, 7 Mar 2023 10:28:58 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-usb@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/3] usb: ucsi: Fix NULL pointer deref in
 ucsi_connector_change()
Message-ID: <ZAcD2qC4KUMkdOmx@kroah.com>
References: <20230306103359.6591-1-hdegoede@redhat.com>
 <20230306103359.6591-2-hdegoede@redhat.com>
 <ZAcBEX4p7uqNL1lg@kuha.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAcBEX4p7uqNL1lg@kuha.fi.intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 07, 2023 at 11:17:05AM +0200, Heikki Krogerus wrote:
> Hi Hans,
> 
> On Mon, Mar 06, 2023 at 11:33:57AM +0100, Hans de Goede wrote:
> > When ucsi_init() fails, ucsi->connector is NULL, yet in case of
> > ucsi_acpi we may still get events which cause the ucs_acpi code to call
> > ucsi_connector_change(), which then derefs the NULL ucsi->connector
> > pointer.
> > 
> > Fix this by not setting ucsi->ntfy inside ucsi_init() until ucsi_init()
> > has succeeded, so that ucsi_connector_change() ignores the events
> > because UCSI_ENABLE_NTFY_CONNECTOR_CHANGE is not set in the ntfy mask.
> > 
> > Fixes: bdc62f2bae8f ("usb: typec: ucsi: Simplified registration and I/O API")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> 
> There is now a bug report for this in the kernel.org bugzilla. Can you
> add a Link tag pointing to it so the it gets updated automagically:
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=217106

My tools should pick this up, thanks.

greg k-h
